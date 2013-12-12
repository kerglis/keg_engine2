module KegHelper

  def reset_form_button
    "<button class='btn' data-reset-form='true'><i class='fa fa-times'></i> #{t("reset_form")}</button>".html_safe
  end

  def pretty_photo(image, image_style, image_params = {})
    link_to(image_tag(image.attachment.url(image_style), image_params), image.attachment.url(:original), rel: "prettyPhoto[#{image.uploadable.id}]", title: image.description) if image
  end

  def admin_namespace?
    controller.class.name.split("::").first == "Admin"
  end

  def icon_boolean_selector(f, method, icon_true, icon_false, title_true = "", title_false = "")
    render "admin/shared/icon_boolean_selector", f: f, method: method, title_true: title_true, title_false: title_false, icon_true: icon_true, icon_false: icon_false
  end

  def link_to_edit(resource, options = {})
    editable = resource.editable? rescue true # ja nav f-cija - ļaujam rediģēt
    options.reverse_merge! url: edit_resource_url(resource) unless options.key? :url
    text = options[:text] rescue ""
    link_to(text.to_s + icon('edit', title: I18n.t("edit")), options[:url], options.update(class: 'iconlink')) if editable
  end

  def link_to_destroy(resource, options = {})
    options.assert_valid_keys(:url, :confirm, :label)
    options.reverse_merge! url: resource_url(resource) unless options.key? :url
    options.reverse_merge! confirm: t("confirm_delete")
    options.reverse_merge! label: fa_icon("times-circle", "fa-red") unless  options.key? :label

    in_params = {
      remote:    true,
      method:    :delete,
      data:      { confirm:   options[:confirm] }
    }

    link_to(options[:label], options[:url], in_params)
  end

  def fa_icon(icon, extra_class = "")
    "<i class='fa fa-#{icon} #{extra_class}'></i>".html_safe
  end

  def twicon(icon)
    "<i class='icon-#{icon}'></i>".html_safe
  end

  def phone_to_top
    "<div class='visible-phone'><a href='#top'>#{twicon "arrow-up"} #{t("navi.to_top")}</a></div>".html_safe
  end

  def link_to_delete(resource, options = {})
    link_to_destroy(resource, options)
  end

  def link_to_remove_fields(name, f, options = {})
    f.hidden_field(:_destroy) + link_to_function(name, "$.fn.remove_fields(this)", options)
  end

  def link_to_add_fields(name, f, association, options = {})
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, child_index: "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to_function(name, "$.fn.add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")", options)
  end

  def link_to_swap(resource, options = {})
    options.reverse_merge! url:      resource_url(resource)      unless options.key? :url
    options.reverse_merge! confirm:  t("confirm.deactivate")     unless options.key? :confirm
    options.reverse_merge! state:    resource.state == "active"  unless options.key? :state
    options.reverse_merge! action:   :swap                       unless options.key? :action

    path = Rails.application.routes.recognize_path(options[:url])
    swap_path = {controller: path[:controller], id: resource.to_param, action: options[:action] }

    icn = (options[:state])       ? icon_active(options) : icon_inactive(options)
    in_options = {
      method: :get,
      data: { confirm: options[:confirm] },
      remote: true
    }
    in_options.delete(:data) unless options[:state]

    link_to icn, swap_path, in_options
  end

  def link_to_swap_field(resource, options = {}, html = {})
    options.reverse_merge! url:      resource_url(resource)      unless options.key? :url
    options.reverse_merge! action:   :swap_field                 unless options.key? :action
    options.reverse_merge! html: {}                              unless options.key? :html

    field_name = options[:field]

    html[:title] ||= I18n.t("swap")
    path = Rails.application.routes.recognize_path(options[:url])
    swap_path = {controller: path[:controller], id: resource.to_param, action: options[:action], field: field_name }
    icn = (resource[field_name]) ? icon_active(options) : icon_inactive(options)

    link_to(icn, swap_path, { remote: true }, html)
  rescue
    "-"
  end

  def link_to_swap_preference(resource, options = {}, html = {})
    options.reverse_merge! url:      resource_url(resource)      unless options.key? :url
    options.reverse_merge! action:   :swap_preference            unless options.key? :action
    options.reverse_merge! html: {}                              unless options.key? :html

    pref_name = options[:pref]

    html[:title] ||= I18n.t("swap")
    path = Rails.application.routes.recognize_path(options[:url])
    swap_path = {controller: path[:controller], id: resource.to_param, action: options[:action], pref: pref_name }

    icn = (resource.prefs[pref_name]) ? icon_active(options) : icon_inactive(options)

    link_to(icn, swap_path, {remote: true}, html)
#  rescue
#    "-"
  end

  def state_events_select(resource, options = {}, html = {})
    unless options.key? :url
      path = Rails.application.routes.recognize_path(options[:url])
      options[:url] = {controller: path[:controller], id: resource.to_param, action: :set_state_to }
    end

    render "state_events_select", resource: resource, options: options, html: html
  end


  def flag(locale, options = {})
    image_tag("flags/#{locale}.png", options)
  end

  def icon(icon_name, options = {})
    options[:width] ||= 16
    options[:height] ||= 16
    image_tag("icons/#{icon_name}.png", options)
  end

  def self.icon_a(icon_name, options = {})
    image_tag("icons/#{icon_name}.png", options)
  end

  def icon_active(options = {})
    fa_icon("check-circle", "fa-green")
  end

  def icon_inactive(options = {})
    fa_icon("check-circle", "fa-gray")
  end

  def state_icon(resource)
    case resource.state
    when "active"
      icon("tick-circle")
    when "inactive"
      icon("cross-circle")
    end
  end

  def attachment_link(asset)
    link_to(icon(asset.icon) + " " + asset.attachment_file_name, asset.attachment.url) if asset
  end

  # Make an admin tab that coveres one or more resources supplied by symbols
  # Option hash may follow. Valid options are
  #   * :label to override link text, otherwise based on the first resource name (translated)
  #   * :route to override automatically determining the default route
  #   * :match_path as an alternative way to control when the tab is active, /products would match /admin/products, /admin/products/5/variants etc.
  def tab(*args)
    options = {label: args.first.to_s }
    if args.last.is_a?(Hash)
      options = options.merge(args.pop)
    end
    options[:route] ||=  "admin_#{args.first}"
    options[:extra_html] ||= ""

    destination_url = options[:url] || send("#{options[:route]}_path")

    klass = options[:label].to_s.classify.constantize

    name = options[:name] || t2(klass)

    if can? :read, klass
      link = link_to( name+ options[:extra_html], destination_url)

      css_classes = []

      selected = if options[:match_path]
        pattern = (options[:match_path].class == Array) ? options[:match_path].join('|') : options[:match_path]
        request.path.index(/\/admin\/?(#{pattern})/) != nil
      else
        args.include?(controller.controller_name.to_sym)
      end
      css_classes << 'active' if selected

      if options[:css_class]
        css_classes << options[:css_class]
      end
      content_tag('li', link, class: css_classes.join(' '))
    end
  end

end
