class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  # devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :email, :password, :password_confirmation, :remember_me

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :registerable, :recoverable, :trackable, :validatable, :omniauthable

  attr_accessible   :email, :first_name, :last_name, :password, :password_confirmation
  attr_accessible   :admin, :gender

  class << self

    def find_for_facebook_oauth(access_token, signed_in_resource = nil)
      data = access_token.extra.raw_info
      if user = find_by_email(data["email"])
        user
      else
        create!(read_oauth_params(data))
      end
    end

    def read_oauth_params(data)
      params = {
        email:       extract_email(data),
        password:    Devise.friendly_token[0,20],
        gender:      data["gender"].first,
        first_name:  data["first_name"],
        last_name:   data["last_name"],
        birth_date:  data["birthday"].try(:to_date)
      }
    end

    def extract_email(data)
      email = data.email
      email ||= data.username
      email ||= data.id
      email
    end

    def current=(user)
      Thread.current[:user_current] = user
    end

    def current
      Thread.current[:user_current]
    end
  end

  def is_admin?
    admin?
  end

  def deletable?
    ! admin?
  end

  def greeting
    full_name.blank? ? email : full_name
  end

  def full_name
    [first_name, last_name].compact.join(" ")
  end

  def age
    (! birth_date.blank?) ? (Time.now.to_date - birth_date.to_date).to_i/365 : 0
  end

end