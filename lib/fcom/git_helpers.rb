# frozen_string_literal: true

# This class contains helpers that extract information from `git`.
class Fcom::GitHelpers
  def repo
    # git@github.com:davidrunger/fcom.git
    # https://github.com/davidrunger/fcom.git
    origin_fetch_url.match(%r{github\.com[:/](.*)\.git})[1]
  end

  private

  def origin_fetch_url
    origin_remote_info = `git remote show origin`
    origin_remote_info.match(/Fetch URL: (.*)$/)[1]
  end
end
