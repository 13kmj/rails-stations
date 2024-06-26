# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :environment, "development"
set :output, "log/cron_log.log"

env :PATH, ENV['PATH'] 
env :GEM_HOME, ENV['GEM_HOME']

every 1.day, at: '7:00 pm' do
  rake "reminder_mailer:send_reminders"
end

every :day, at: '12:00am' do
  rake 'update:daily_rankings'
end