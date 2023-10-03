# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
    before_validation :ensure_session_token

    validates :username, :session_token, presence: true, uniqueness: true
    validates :password_digest, presence: true 
    validates :session_token, uniqueness: {scope: :username}
    validates :password, length {minimum: 6, allow_nil: true}

    after_validation :ensure_session_token

    attr_reader :password

    def password=(password)
        @password = password
        self.password_digest = BCrypt::Password.create(password) # salts and hashes the plain text pw
    end

    def is_password?(password)
        # checking if user login password = to attempted login pw
        password_object = BCrypt::Password.new(self.password_digest)
        password_object.is_password?(password) # built-in BCrypt#is_password? method
        # takes plain text, adds salt hashes checks to see if it is the same as the BCPO pw digest
    end

    def self.find_by_credentials(username, password)
        user = User.find_by(username: username)
        if is_password?(password) && user
            return user
        else
            nil
        end
    end

    def ensure_session_token
        self.session_token ||= SecureRandom::urlsafe_base64
    end

    def reset_session_token!
        self.session_token = SecureRandom::urlsafe_base64
        self.save!
        self.session_token
    end

    private
    def generate_unique_session_token
        SecureRandom::urlsafe_base64
    end
end
