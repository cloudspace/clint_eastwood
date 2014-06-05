require 'thor'
require 'clint_eastwood'

module ClintEastwood
  class CLI < Thor
    option :path
    default_task :lint

    desc 'lint', 'Lints the given project directory'
    def lint
      options[:path] ||= File.expand_path('.')

      clint = ClintEastwood::TheEnforcer.new options[:path]

      abort('Linting Failed') unless clint.enforce
      puts 'Project passed the linter successfully'
    end
  end
end