# Defines our constants
PADRINO_ENV  = ENV['PADRINO_ENV'] ||= ENV['RACK_ENV'] ||= 'development'  unless defined?(PADRINO_ENV)
PADRINO_ROOT = File.expand_path('../..', __FILE__) unless defined?(PADRINO_ROOT)
AUTH_ID = "MAZGY4ODEXZTLMZTQ1YJ"
AUTH_TOKEN = "M2Q4YmFkMTc4ZDljNmMzMTM3Nzk0N2FkNDVkYjhm" 
# Load our dependencies
require 'rubygems' unless defined?(Gem)
require 'bundler/setup'
Bundler.require(:default, PADRINO_ENV)

##
# Enable devel logging
#
# Padrino::Logger::Config[:development][:log_level]  = :devel
# Padrino::Logger::Config[:development][:log_static] = true
#

##
# Add your before load hooks here
#
Padrino.before_load do
end

##
# Add your after load hooks here
#
Padrino.after_load do
end
Padrino.use Rack::Session::Cookie, :session_secret => 'c858cd0bd370ab51efff3ed733776912af4d052e85989257f68f73e903f651fd'

Padrino::Logger::Config[:development][:stream] = :stdout
Padrino::Logger::Config[:production] = { :log_level => :debug, :stream => :stdout}

Padrino.load!
