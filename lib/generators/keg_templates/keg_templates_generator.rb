class KegTemplatesGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def generate_keg_templates
    files = ["_form", "show", "edit", "index", "new"]

    files.each do |file|
      copy_file "#{file}.html.haml", "lib/templates/haml/scaffold/#{file}.html.haml"
    end
  end

end