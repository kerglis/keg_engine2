class User < ActiveRecord::Base

  include StdState

  devise :database_authenticatable, :rememberable, :registerable, :recoverable, :trackable, :validatable, :omniauthable, :confirmable

  after_create :activate

  class << self

    def permitted_params
      [
        :first_name, :last_name, :phone, :password,
        :is_company, :company_name,  :company_reg_no, :company_address, :company_bank_info,
        :address_city, :address_street, :address_zip
      ]
    end

    def find_for_facebook_oauth(access_token, signed_in_resource = nil)
      data = access_token.extra.raw_info
      if user = find_by_email(data["email"])
        user
      else
        user = create!(read_oauth_params(data))
        user.confirm!
      end
    end

    def read_oauth_params(data)
      params = {
        email:       extract_email(data),
        password:    Devise.friendly_token[0,20],
        first_name:  data["first_name"],
        last_name:   data["last_name"]
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

end