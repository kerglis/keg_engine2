module SetUser
  extend ActiveSupport::Concern

  included do
    validates :user, presence: true
    before_validation :set_user
    belongs_to :user

    private

    def set_user
      self.user ||= User.current
    end
  end
end
