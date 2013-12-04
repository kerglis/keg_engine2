#coding: utf-8
module Permalinks

  def self.included(base)
    base.class_eval do

      def to_param
        [id, permalink].join("-").to_url
      end

      def make_permalinks
        self.class.locales.each do |locale|
          the_name = send("name_#{locale}")
          link = the_name.to_url.gsub("'", "").to_s
          self.send("permalink_#{locale}=", link)
          # self.send("full_path_#{locale}=", make_full_path)
        end
      end

      def make_permalink(force_it = false)
        self.permalink = name if self.permalink.blank?
        self.permalink = self.permalink.to_url.gsub("'", "").to_s
      end

      def make_full_path
        parts = [ ]
        parts << ancestors.map(&:permalink) unless ancestors.empty?
        parts << permalink
        parts.compact.join("/")
      end

    end
  end

end