class User:
    def __init__(self, UUID, username, email, password_hash):
        self.UUID = UUID
        self.username = username
        self.email = email
        self.password_hash = password_hash