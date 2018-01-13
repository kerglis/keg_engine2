class ActiveRecord::Base
  def can_destroy?
    self.class.reflect_on_all_associations.all? do |assoc|
      assoc.options[:dependent] != :restrict_with_exception ||
        (assoc.macro == :has_one && send(assoc.name).nil?) ||
        (assoc.macro == :has_many && send(assoc.name).empty?)
    end
  end
end
