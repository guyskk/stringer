#!/usr/local/bin/ruby
require 'optparse'

def wait_postgres
  until system("ping -c1 postgres > /dev/null 2>&1") do
      puts("Waiting for postgres started")
      sleep(1)
  end
  sleep(3)
end

OptionParser.new do |opts|
  opts.banner = "Usage: start.rb COMMAND"

  opts.order! do |command|
    if command == "app" then
      wait_postgres
      exec("unicorn -p 80 -c ./config/unicorn.rb")

    elsif command == "crontab" then
      wait_postgres
      while true do
        system("bundle exec rake fetch_feeds")
        sleep(300)
      end

    elsif command == "init" then
      wait_postgres
      system("bundle exec rake db:migrate")

    else
      puts("Command must be one of [app, init, crontab]")
    end
  end
end.parse!
