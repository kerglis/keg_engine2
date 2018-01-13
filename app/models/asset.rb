class Asset < ActiveRecord::Base
  belongs_to :uploadable, polymorphic: true

  acts_as_list scope: %i[uploadable_id uploadable_type]

  scope :ordered, -> { order(:position) }

  def self.permitted_params
    %i[
      id
      attachment
      uploadable_type
      uploadable_id
      description
      position
      _destroy
    ]
  end
end
