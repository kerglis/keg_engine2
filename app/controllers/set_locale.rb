module SetLocale

  def self.included(base)
    base.class_eval do

      before_filter :set_locale

      def set_locale
        @locales = AppConfig[:locales].map(&:to_sym)
        locale = params[:locale].to_sym rescue nil
        I18n.locale = locale if @locales.include?(locale)
        I18n.locale ||= @locales.first
        @locale = I18n.locale
      end

      def default_url_options(options={})
        { locale: I18n.locale }
      end

    end
  end

end
