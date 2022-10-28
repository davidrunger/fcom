# frozen_string_literal: true

# This class contains helpers that extract information from `git`.
class Fcom::GitHelpers
  def repo
    # Examples:
    # git@github.com:davidrunger/fcom.git
    # https://github.com/davidrunger/fcom.git
    # https://github.com/davidrunger/fcom
    origin_fetch_url.delete_suffix('/').match(%r{github\.com[:/](((?!\.git).)*)})[1]
  end

  private

  def origin_fetch_url
    origin_remote_info = `git remote -v`
    origin_remote_info.match(/origin\s+(.*)\s+\(fetch\)$/)[1]
  end
end
