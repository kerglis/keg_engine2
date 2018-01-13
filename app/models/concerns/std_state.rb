module StdState
  extend ActiveSupport::Concern

  included do
    scope :active, -> { where(state: :active) }

    state_machine initial: :inactive do
      event :activate do
        transition  to: :active,
                    from: :inactive,
                    if: :valid_for_activation?
      end

      event :deactivate do
        transition to: :inactive, from: :active
      end

      event :swap do
        transition  active: :inactive,
                    inactive: :active,
                    if: ->(obj) { obj.active? || obj.valid_for_activation? }
      end
    end

    def self.find_for_authentication(_conditions = {})
      find_by(state: :active)
    end

    def valid_for_activation?
      valid?
    end
  end
end
