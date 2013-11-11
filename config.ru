require File.join(File.dirname(__FILE__), 'app')

set :environment, ENV["environment"] || :development

FileUtils.mkdir_p 'log'
log = File.new("log/sinatra.log", "a+")

$stdout.reopen(log)
$stderr.reopen(log)

run Spambust::App
