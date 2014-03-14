module SetUser

  def self.included(base)
    base.instance_eval do
      validates_presence_of :user
      before_validation :set_user
      belongs_to :user
    end
  end

  private

  def set_user
    self.user ||= User.current
  end

end