module ByPreference

  def self.included(base)
    base.instance_eval do
      has_many  :prefs, class_name: "Preference", conditions: "preferences.owner_type = '#{self.class_name}'", foreign_key: :owner_id
    end

    base.class_eval do
      def self.by_preference(name, value)
        joins(:prefs).where(preferences: {name: name, value: value})
      end
    end
  end

end