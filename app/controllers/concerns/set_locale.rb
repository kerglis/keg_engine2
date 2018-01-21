module SetLocale
  extend ActiveSupport::Concern

  included do
    before_action :set_locale
  end

  def set_locale
    @locales = AppConfig[:locales].map(&:to_sym)
    locale = params[:locale].to_sym if params[:locale]
    I18n.locale = locale if @locales.include?(locale)
    I18n.locale ||= @locales.first
    @locale = I18n.locale
  end

  def default_url_options(_options = {})
    { locale: I18n.locale }
  end
end
