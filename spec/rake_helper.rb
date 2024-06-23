# spec/rake_helper.rb
require 'rake'
require 'rspec'

# Rakeファイルを読み込み
Rake.application.rake_require('tasks/reminder_mailer', [Rails.root.join('lib/tasks')])
Rake.application.rake_require('tasks/update_rankings', [Rails.root.join('lib/tasks')])
Rake::Task.define_task(:environment)
