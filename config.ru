require "./app/app.rb"

# makes puts print to stdout:
$stdout.sync = true

run Sinatra::Application
