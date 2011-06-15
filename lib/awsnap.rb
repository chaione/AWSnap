require 'active_support/dependencies/autoload'
require 'active_support/core_ext/numeric/time'
require 'active_support/core_ext/hash'
require 'uri'
require 'hmac-sha2'
require 'base64'

module Awsnap
  extend ActiveSupport::Autoload
  autoload :Request
end
