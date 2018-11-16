# frozen_string_literal: true

module Slugable
  extend ActiveSupport::Concern

  included do
    validates :slug, presence: true, format: { with: BookLab::Slug::REGEXP }, length: 2..128

    before_validation do
      self.slug = self.slug.downcase if self.slug.present?
    end
  end

  def fullname
    @fullname ||= "#{self.name} (#{self.slug})"
  end

  def to_param
    slug
  end

  def to_url
    [Setting.host, self.to_path].join("")
  end

  def find_by_slug!(slug)
    find_by!(slug: slug) rescue ActiveRecord::RecordNotFound
  end
end
