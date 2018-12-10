module KegHelper
  def reset_form_button
    %(
      <button class='btn' data-reset-form='true'>
        <i class='fa fa-times'></i>
        <span class='hidden-phone'>
          #{t('reset_form')}
        </span>
      </button>
    ).html_safe
  end

  def pretty_photo(image, image_style, image_params = {})
    link_to(
      image_tag(image.attachment.url(image_style), image_params),
      image.attachment.url(:original),
      rel: "prettyPhoto[#{image.uploadable.id}]",
      title: image.description
    ) if image
  end

  def admin_namespace?
    controller.class.name.split('::').first == 'Admin'
  end

  def icon_boolean_selector(f, method, icon_true, icon_false, title_true = '', title_false = '')
    render(
      'admin/shared/icon_boolean_selector',
      f: f,
      method: method,
      title_true: title_true,
      title_false: title_false,
      icon_true: icon_true,
      icon_false: icon_false
    )
  end

  def ransack_boolean(f, left_method, right_method, left_icon, right_icon, title = '')
    render(
      'ransack_boolean',
      f: f,
      left_method: left_method,
      right_method: right_method,
      left_icon: left_icon,
      right_icon: right_icon,
      title: title
    )
  end

  # def fa_icon(icon, extra_class = "")
  #   "<i class='fa fa-#{icon} #{extra_class}'></i>".html_safe
  # end

  def twicon(icon)
    "<i class='icon-#{icon}'></i>".html_safe
  end

  def exception_icon(e)
    link_to fa_icon('exclamation-triangle'), '#', title: e.to_s + e.backtrace.join("\n")
  end

  def phone_to_top
    %(
      <div class='visible-phone'>
        <a href='#top'>
          #{fa_icon('arrow-up')} #{t('navi.to_top')}
        </a>
      </div>
    ).html_safe
  end

  def link_to_delete(resource, options = {}, html = {})
    link_to_destroy(resource, options, html)
  end

  def link_to_destroy(resource, options = {}, html = {})
    return if resource.respond_to?(:can_destroy?) && !resource.can_destroy?

    options.reverse_merge! url: resource_url(resource) unless options.key?(:url)
    options.reverse_merge! confirm: t('confirm.delete')

    in_params = {
      remote: true,
      method: :delete,
      data: { confirm: options[:confirm] }
    }.merge(html)

    link_to(fa_icon('times-circle', class: 'fa-red'), options[:url], in_params)
  rescue StandardError => e
    exception_icon(e)
  end

  def link_to_remove_fields(name, f, options = {})
    f.hidden_field(:_destroy) + link_to_function(name, '$.fn.remove_fields(this)', options)
  end

  def link_to_add_fields(name, f, association, options = {})
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, child_index: "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to_function(name, "$.fn.add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")", options)
  end

  def link_to_swap(resource, options = {}, html = {})
    options.reverse_merge! url:      resource_url(resource)      unless options.key? :url
    options.reverse_merge! confirm:  t('confirm.deactivate')     unless options.key? :confirm
    options.reverse_merge! state:    resource.active?            unless options.key? :state
    options.reverse_merge! action:   :swap                       unless options.key? :action

    path = Rails.application.routes.recognize_path(options[:url])
    swap_path = path.merge(action: options[:action])

    icn = options[:state] ? icon_active : icon_inactive
    in_options = {
      method: :get,
      data: { confirm: options[:confirm] },
      remote: true
    }.merge(html)
    in_options.delete(:data) unless options[:state]

    link_to(icn, swap_path, in_options)
  rescue StandardError => e
    exception_icon(e)
  end

  def link_to_swap_field(resource, options = {}, html = {})
    options.reverse_merge! url:      resource_url(resource)      unless options.key? :url
    options.reverse_merge! action:   :swap_field                 unless options.key? :action
    options.reverse_merge! html: {}                              unless options.key? :html
    options.reverse_merge! active_class: "fa-green"              unless options.key? :active_class
    options.reverse_merge! inactive_class: "fa-gray"             unless options.key? :inactive_class

    field_name = options[:field]

    html[:title] ||= I18n.t('swap')
    html[:remote] = true

    path = Rails.application.routes.recognize_path(options[:url])
    swap_path = path.merge(action: options[:action], field: field_name)

    klass = resource[field_name] ? :active_class : :inactive_class
    icn = fa_icon(options[:icon], class: options[klass])

    link_to(icn, swap_path, html)
  rescue StandardError => e
    exception_icon(e)
  end

  def link_to_swap_setting(resource, options = {}, html = {})
    options.reverse_merge! url:      resource_url(resource) unless options.key? :url
    options.reverse_merge! action:   :swap_setting          unless options.key? :action
    options.reverse_merge! html: {}                         unless options.key? :html
    options.reverse_merge! active_class: 'fa-green'         unless options.key? :active_class
    options.reverse_merge! inactive_class: 'fa-gray'        unless options.key? :inactive_class

    setting = options[:setting]

    html[:title] ||= I18n.t('swap')
    html[:remote] = true

    path = Rails.application.routes.recognize_path(options[:url])
    swap_path = path.merge(action: options[:action], setting: setting)

    klass = resource.send("#{setting}?") ? :active_class : :inactive_class
    icn = fa_icon(options[:icon], class: options[klass])

    link_to(icn, swap_path, html)
  rescue StandardError => e
    exception_icon(e)
  end

  def state_events_select(resource, options = {}, html = {})
    unless options.key? :url
      path = Rails.application.routes.recognize_path(options[:url])
      options[:url] = path.merge(action: :set_state_to)
    end

    render 'state_events_select', resource: resource, options: options, html: html
  end

  def state_buttons(resource, options = {}, html = {})
    unless options.key? :url
      path = Rails.application.routes.recognize_path(options[:url])
      options[:url] = path.merge(action: :set_state_to)
    end

    render 'state_buttons', resource: resource, options: options, html: html
  end

  def flag(locale, options = {})
    image_tag("flags/#{locale}.png", options)
  end

  def icon_old(icon_name, options = {})
    options[:width] ||= 16
    options[:height] ||= 16
    image_tag("icons/#{icon_name}.png", options)
  end

  def self.icon_a(icon_name, options = {})
    image_tag("icons/#{icon_name}.png", options)
  end

  def icon_active
    fa_icon('check-circle', class: 'fa-green')
  end

  def icon_inactive
    fa_icon('check-circle', class: 'fa-gray')
  end

  def state_icon(resource)
    case resource.state
    when 'active'
      icon_active
    when 'inactive'
      icon_inactive
    end
  end

  def attachment_link(asset)
    link_to(
      icon(asset.icon) +
      ' ' +
      asset.attachment_file_name, asset.attachment.url
    ) if asset
  end

  # Make an admin tab that coveres one or more resources supplied by symbols
  # Option hash may follow. Valid options are
  #   * :label to override link text, otherwise based on the first resource name (translated)
  #   * :route to override automatically determining the default route
  #   * :match_path as an alternative way to control when the tab is active, /products would match /admin/products, /admin/products/5/variants etc.
  def tab(*args)
    options = { label: args.first.to_s }

    options = options.merge(args.pop) if args.last.is_a?(Hash)
    options[:route] ||=  "admin_#{args.first}"
    options[:extra_html] ||= ''

    destination_url = options[:url] || send("#{options[:route]}_path")

    klass = options[:label].to_s.classify.constantize

    name = options[:name] || t2(klass)

    return unless can? :read, klass
    link = link_to((name + options[:extra_html]).html_safe, destination_url)

    pattern = if options[:match_path].is_a?(Array)
                options[:match_path].join('|')
              else
                options[:match_path]
              end

    selected =  if options[:match_path]
                  !request.path.index(%r{/admin/?(#{pattern})}).nil?
                else
                  args.include?(controller.controller_name.to_sym)
                end

    css_classes = []
    css_classes << 'active' if selected
    css_classes << options[:css_class] if options[:css_class]

    content_tag('li', link.html_safe, class: css_classes.join(' '))
  end
end
