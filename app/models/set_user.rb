module SetUser

  def self.included(base)
    base.instance_eval do
      validates_presence_of :user
      before_validation :set_user
      belongs_to :user
      attr_accessible :user, :user_id
    end
  end

  private

  def set_user
    self.user ||= User.current
  end

end