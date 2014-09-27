class Asset < ActiveRecord::Base

  belongs_to :uploadable, polymorphic: true

  acts_as_list

  scope :ordered, -> { order(:position) }

  class << self

    def permitted_params
      [ :id, :attachment, :uploadable_type, :uploadable_id, :description, :position, :_destroy ]
    end

  end

  def scope_condition
    "assets.uploadable_id = #{uploadable_id} and assets.uploadable_type='#{uploadable_type}'"
  end

end