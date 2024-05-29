class Record:
    def __init__(self, UUID, type, creator_id, receiver_id, receiver_name, confirmed, receiver_paid, creator_paid, active, date_created, amount, note):
        self.UUID = UUID
        self.type = type   # 0 = creator borrows from receiver, 1 = creator lending to receiver
        self.creator_id = creator_id
        self.receiver_id = receiver_id
        self.receiver_name = receiver_name   # in case receiver doesnt have an account, can use name (expansion feature)
        self.confirmed = confirmed   # receiver confirms record as being correct
        self.receiver_paid = receiver_paid   # receiver confirms record as being paid
        self.creator_paid = creator_paid   # creator confirms record as being paid
        self.active = active   # if already marked as paid by both, record becomes inactive
        self.date_created = date_created
        self.amount = amount
        self.note = note