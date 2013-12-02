module Locales
  def self.included(base)
    base.class_eval do

      def self.locales
        AppConfig.locales.map(&:to_sym)
      end

      def param_str(locale = nil)
        Globalize.with_locale(locale) do
          to_param
        end
      end

      def to_param(method = :name)
        parents = self_and_ancesors rescue nil

        parts = if parents
          [ id, parents.map{|p| p.permalink(method)} ]
        else
          [ id, permalink ]
        end

        parts.compact.join("-")
      end

      def permalink(method = :name)
        from = send(method) rescue ""
        from.to_url.gsub(/['<>]/, "").to_s rescue ""
      end

      def path(locale, params = {})
        method = self.class.to_s.underscore
        Rails.application.routes.url_helpers.send("#{method}_path", self, params.merge({locale: locale})).gsub(/#{param_str}$/, param_str(locale))
      end

      def make_temp_names
        self.class.locales.each do |l|
          Globalize.with_locale(l) do
            self.name = "#{self.class.to_s} #{l.to_s.upcase} #{Time.now.to_i}" unless self.name.present?
          end
        end
      end

    end
  end
end