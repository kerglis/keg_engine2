module TranslationHelper
  def t(str = "", options = {})
    return if str.nil?
    options.merge!(raise: I18n::MissingTranslationData) unless options.key?(:raise)

    begin
      value = super(str, options)
    rescue I18n::MissingTranslationData
      value = str.split(".").last.humanize
    end
    value
  end

  def tt(object, method)
    # smart translate object method - including submodel
    unless (method.to_s =~ /^(.+)\.([^\.]+)$/).nil?
      # submodel
      object = object.send($1)
      method = $2
    end
    str = (object.class.to_s == "Class") ? object.human_attribute_name(method) : object.to_model.class.human_attribute_name(method)
    str ||= t(method.to_s)
    str.html_safe
  rescue
    t(method.to_s).html_safe
  end

  def t1(klass)
    # singular model name
    klass.model_name.human
  end

  def t2(klass)
    # plural model name
    klass.model_name.human(count: 2)
  end

  def tN(klass)
    I18n.t("create_new", model: klass.model_name.human)
  end

  def tE(klass)
    I18n.t("edit_model", model: klass.model_name.human)
  end

end