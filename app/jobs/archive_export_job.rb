# frozen_string_literal: true

class ArchiveExportJob < ApplicationJob
  def perform(repo)
    return nil if repo.blank?
    return nil unless repo.is_a(Repository)

    exporter = GitBook::Export::Archive.new(repo)
    exporter.perform
  rescue => e
    BookLab::Error.track(e, title: "ArchiveExportJob [repo #{repo.slug}] error")
  ensure
    repo.set_export_status(:archive, "done")
  end
end
