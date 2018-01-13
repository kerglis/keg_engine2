module ByPreference
  extend ActiveSupport::Concern

  included do
    has_many  :prefs,
              class_name: 'Preference',
              conditions: "preferences.owner_type = '#{class_name}'",
              foreign_key: :owner_id

    scope :by_preference, ->(name, value) {
      joins(:prefs)
        .where(preferences: { name: name, value: value })
    }
  end
end
