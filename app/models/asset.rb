class Asset < ActiveRecord::Base

  belongs_to :uploadable, polymorphic: true

  attr_accessible :attachment, :description, :uploadable_id, :uploadable_type, :uploadable

  acts_as_list

  def scope_condition
    "assets.uploadable_id = #{uploadable_id} and assets.uploadable_type='#{uploadable_type}'"
  end

  def validate
    unless attachment.errors.empty?
      errors.add :attachment, "Paperclip returned errors for file '#{attachment_file_name}' - check ImageMagick installation or image source file."
      false
    end
  end

end