module StdState

  def self.included(base)
    base.class_eval do

      scope :active,  where(state: :active)

      state_machine initial: :inactive do

        event :activate do
          transition to: :active, from: :inactive, if: :valid_for_activation?
        end

        event :deactivate do
          transition to: :inactive, from: :active
        end

        event :swap do
          transition  active: :inactive, inactive: :active, if: lambda {|obj| obj.active? || obj.valid_for_activation? }
        end
      end

      def self.find_for_authentication(conditions={})
        conditions[:state] = "active"
        find(:first, conditions: conditions)
      end

      def valid_for_activation?
        valid?
      end

    end
  end

end