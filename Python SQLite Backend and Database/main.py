import sqlite3
from User import User   # python class User
from Record import Record   # python class Record
from datetime import date

conn = sqlite3.connect('lj_borrow.db', check_same_thread=False)   # connects to database in file lj_borrow.db
conn.execute("PRAGMA foreign_keys = 1")   # enables use of foreign keys
c = conn.cursor()

from flask import Flask, request, jsonify
from itsdangerous import URLSafeTimedSerializer as Serializer, BadSignature, SignatureExpired  # generate login tokens
from functools import wraps

app = Flask(__name__)   # uses Flask to make RESTful API
app.config['SECRET_KEY'] = 'lengjai'

# Generate token for app log in
def generate_token(user_id):
    s = Serializer(app.config['SECRET_KEY'])
    print('generated token:', s.dumps({'user_id': user_id}))
    return s.dumps({'user_id': user_id})

# Protected routes requiring token
def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = request.headers.get('x-access-tokens')
        if not token:
            return jsonify({'message': 'Token is missing'}), 403
        try:
            s = Serializer(app.config['SECRET_KEY'])
            data = s.loads(token)
            current_user = get_user_by_id(data['user_id'])
        except SignatureExpired:
            return jsonify({'message': 'Token has expired'}), 403
        except BadSignature:
            return jsonify({'message': 'Invalid token'}), 403
        return f(current_user, *args, **kwargs)
    return decorated

def get_user_by_id(UUID):
    with conn:
        c.execute("SELECT FROM users WHERE UUID = :UUID", {'UUID': UUID})

# Sample Users
abi = User(1, 'abi', 'abishai.halim@gmail.com', '12345678')
ryan = User(2, 'ryan', 'ryan.chan@gmail.com', '12345678')
joseph = User(3, 'joseph', 'joseph.rama@gmail.com', '12345678')

# Users

# go to localhost:5000//create_user/uuid=<int:UUID>&username=<string:username>&email=<string:email>&password_hash=<string:password_hash>/ to make new user
@app.route('/create_user/uuid=<int:UUID>&username=<string:username>&email=<string:email>&password_hash=<string:password_hash>/', methods=['GET'])
def create_user(UUID, username, email, password_hash):   # function to insert a python object of class User into database
    new_user = User(UUID, username, email, password_hash)
    with conn:
        c.execute("INSERT INTO users VALUES (:UUID, :username, :email, :password_hash)",
                  {'UUID': new_user.UUID, 'username': new_user.username, 'email': new_user.email, 'password_hash': new_user.password_hash})
    return f"Succesfully created new user <br>UUID: {new_user.UUID} <br>username: {new_user.username} <br>email: {new_user.email}"

# go to localhost:5000//delete_user/uuid=<int:UUID>/ to delete user
@app.route('/delete_user/uuid=<int:UUID>/', methods=['GET'])
def delete_user(UUID):   # function to delete user from database using user UUID
    with conn:
        c.execute("DELETE FROM users WHERE UUID = :UUID", {'UUID': UUID})
    return f"Succesfully deleted user with UUID {UUID}"

# go to localhost:5000//log_in/
@app.route('/log_in/username=<string:username>&password_hash=<string:password_hash>/', methods=['GET'])
def log_in(username, password_hash):
    # if wrong username
    c.execute("SELECT username, password_hash, UUID FROM users WHERE username = :username", {'username': username})
    userinfo = c.fetchone()  # returns tuple with (username, password, UUID) if there exists user matching username

    if not userinfo:
        return 'User not found', 404   # return 404 user not found

    # if wrong password
    if userinfo[1] != password_hash:
        return 'Wrong password', 403   # return 403 forbidden

    token = generate_token(userinfo[2])
    print(f'logged in, token: {token}')
    return jsonify({"token": token, "userUUID": userinfo[2]}), 200

# get updated latest user UUID for making each account
c.execute("SELECT COUNT(*) FROM users")
rowcount = c.fetchone()[0]
latest_user_UUID = rowcount + 1

@app.route('/register_account/username=<string:username>&email=<string:email>&password_hash=<string:password_hash>/', methods=['GET'])
def register_account(username, email, password_hash):
    global latest_user_UUID
    c.execute("SELECT username FROM users WHERE username = :username", {'username': username})
    existing_user = c.fetchone()

    if existing_user:
        return 'Username already taken', 409

    create_user(latest_user_UUID, username, email, password_hash)
    latest_user_UUID += 1

    return 'Succesfully made new account', 200

# go to localhost:5000//create_record/uuid=<int:UUID>&type=<int:type>&creator_id=<int:creator_id>&receiver_id=<int:receiver_id>&receiver_name=<string:receiver_name>&date_created=<int:date_created>&amount=<int:amount>&note=<string:note>/ to make new record
@app.route('/create_record/uuid=<int:UUID>&type=<int:type>&creator_id=<int:creator_id>&receiver_id=<int:receiver_id>&receiver_name=<string:receiver_name>&date_created=<int:date_created>&amount=<int:amount>&note=<string:note>/', methods=['GET'])   # for now only accept int for amount
def create_record(UUID, type, creator_id, receiver_id, receiver_name, date_created, amount, note):   # function to insert a python object of class Record into database
    new_record = Record(UUID, type, creator_id, receiver_id, receiver_name, 0, 0, 0, 1, date_created, amount, note)
    with conn:
        c.execute("INSERT INTO records VALUES (:UUID, :type, :creator_id, :receiver_id, :receiver_name, :confirmed, :receiver_paid, :creator_paid, :active, :date_created, :amount, :note)",
                  {'UUID':new_record.UUID, 'type':new_record.type, 'creator_id':new_record.creator_id, 'receiver_id':new_record.receiver_id, 'receiver_name':new_record.receiver_name, 'confirmed':0, 'receiver_paid':0, 'creator_paid':0, 'active':1, 'date_created':new_record.date_created, 'amount':new_record.amount, 'note':new_record.note})
    return f"Succesfully created new record <br>UUID: {new_record.UUID} <br>type: {new_record.type} <br>creator_id: {new_record.creator_id} <br>receiver_id: {new_record.receiver_id} <br>receiver_name: {new_record.receiver_name} <br>date_created: {new_record.date_created} <br>amount: {new_record.amount} <br>note: {new_record.note}"

# go to localhost:5000//delete_record/record_uuid=<int:record_UUID>/ to delete record
@app.route('/delete_record/record_uuid=<int:record_UUID>/', methods=['GET'])
def delete_record(record_UUID):   # function to delete record from database using record_UUID
    with conn:
        c.execute("DELETE FROM records WHERE UUID = :UUID", {'UUID': record_UUID})
    return f"Succesfully deleted record with UUID {record_UUID}"

# get updated latest record UUID for making each record
c.execute("SELECT COUNT(*) FROM records")
rowcount = c.fetchone()[0]
latest_record_UUID = rowcount + 1

@app.route('/new_record/type=<int:type>&creator_id=<int:creator_id>&receiver_name=<string:receiver_name>&amount=<int:amount>&note=<string:note>/', methods=['GET'])
def new_record(type, creator_id, receiver_name, amount, note):
    global latest_record_UUID

    # find receiver UUID based on receiver_name
    c.execute("SELECT UUID FROM users WHERE username = :username", {'username': receiver_name})
    receiver_id = c.fetchone()[0]

    # check if receiver == creator
    if receiver_id == creator_id:
        return 'Creator cant be the same as receiver', 400

    print(latest_record_UUID, type, creator_id, receiver_id, receiver_name, date.today(), amount, note)
    create_record(latest_record_UUID, type, creator_id, receiver_id, receiver_name, date.today(), amount, note)
    latest_record_UUID += 1

    return 'Succesfully made new record', 200

@app.route('/get_records/user_uuid=<int:user_uuid>', methods=['GET'])
def get_records(user_uuid):
    if user_uuid == 0:
        return 'No user id specified', 404

    c.execute("SELECT * FROM records WHERE creator_id = :user_UUID OR receiver_id = :user_UUID", {'user_UUID': user_uuid})
    records = c.fetchall()

    #convert records to proper json format
    keys = ['id', 'type', 'creator_id', 'receiver_id', 'receiver_name', 'confirmed', 'receiver_paid', 'creator_paid', 'active', 'date_created', 'amount', 'note']
    records_list = [dict(zip(keys, record)) for record in records]
    records_list.reverse()

    return jsonify(records_list)

def confirm(user_UUID, record_UUID):   # receiver confirms record (as being correct)
    c.execute("SELECT * FROM records WHERE UUID = :record_UUID", {'record_UUID' : record_UUID})
    record = c.fetchone()
    if not record:
        raise Exception(f"Record {record_UUID} not found!")
    if record[5] != 0:
        raise Exception(f"Record {record_UUID} already confirmed!")
    if record[3] != user_UUID:
        raise Exception(f"User {user_UUID} is not receiver of record {record_UUID}!")
    elif record[3] == user_UUID and record[5] == 0:
        with conn:
            c.execute("UPDATE records SET confirmed = 1 WHERE UUID = :record_UUID", {'record_UUID' : record_UUID})
        print(f"Record {record_UUID} confirmed by receiver {user_UUID}")
        pass

def receiver_paid(user_UUID, record_UUID):   # receiver marks record as already being paid
    c.execute("SELECT * FROM records WHERE UUID = :record_UUID", {'record_UUID' : record_UUID})
    record = c.fetchone()
    if not record:
        raise Exception(f"Record {record_UUID} not found!")
    if record[3] != user_UUID:
        raise Exception(f"User {user_UUID} is not receiver of record {record_UUID}!")
    if record[6] != 0:
        raise Exception(f"Receiver {user_UUID} already marked record {record_UUID} as paid!")
    elif record[3] == user_UUID and record[6] == 0:
        with conn:
            c.execute("UPDATE records SET receiver_paid = 1 WHERE UUID = :record_UUID", {'record_UUID' : record_UUID})
        print(f'Receiver {user_UUID} marked record {record_UUID} as paid')
        check_valid(record_UUID)
        pass

def creator_paid(user_UUID, record_UUID):   # creator marks record as already being paid
    c.execute("SELECT * FROM records WHERE UUID = :record_UUID", {'record_UUID' : record_UUID})
    record = c.fetchone()
    if not record:
        raise Exception(f"Record {record_UUID} not found!")
    if record[2] != user_UUID:
        raise Exception(f"User {user_UUID} is not creator of record {record_UUID}!")
    if record[7] != 0:
        raise Exception(f"Creator {user_UUID} already marked record {record_UUID} as paid!")
    elif record[2] == user_UUID and record[7] == 0:
        with conn:
            c.execute("UPDATE records SET creator_paid = 1 WHERE UUID = :record_UUID", {'record_UUID' : record_UUID})
        print(f'Creator {user_UUID} marked record {record_UUID} as paid')
        check_valid(record_UUID)
        pass

def check_valid(record_UUID):   # checks if both receiver and creator marked record as being paid, then makes record inactive
    c.execute("SELECT * FROM records WHERE UUID = :record_UUID", {'record_UUID' : record_UUID})
    record = c.fetchone()
    if record[6] == 1 and record[7] == 1:  # check if both creator and receiver paid, then set inactive
        with conn:
            c.execute("UPDATE records SET active = 0 WHERE UUID = :record_UUID", {'record_UUID': record_UUID})
        print(f'Both creator and receiver marked record {record_UUID} as paid, record no longer active')
        pass
    else:
        print(f'Either creator or receiver has not marked record {record_UUID} as paid, record still active')
        pass

@app.route('/protected', methods=['GET'])
@token_required
def protected(current_user):
    return jsonify({'message': 'This is protected', 'user': current_user.username})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

#creating users table:
#c.execute("""CREATE TABLE users (
#            UUID integer not null primary key,
#            username text not null,
#            email text not null,
#            password_hash text not null
#            )""")

#creating records table:
#c.execute("""CREATE TABLE records (
#            UUID integer not null primary key,
#            type int not null,
#            creator_id integer not null,
#            receiver_id integer not null,
#            receiver_name text,
#            confirmed int not null,
#            receiver_paid int not null,
#            creator_paid int not null,
#            active int not null,
#            date_created int,
#            amount real not null,
#            note text,
#            FOREIGN KEY (creator_id) REFERENCES users (UUID),
#            FOREIGN KEY (receiver_id) REFERENCES users (UUID)
#            )""")
