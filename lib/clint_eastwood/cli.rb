require 'thor'
require 'clint_eastwood'
# Clint Eastwood
module ClintEastwood
  # Clint Eastwood command line interface
  class CLI < Thor
    option :path
    option :lint, type: :array
    option 'disable-rbp', type: :boolean
    option 'disable-rubocop', type: :boolean
    option 'disable-reek', type: :boolean

    default_task :lint

    desc 'lint', 'Lints the given project directory'
    def lint
      path = options[:path] || File.expand_path('.')

      disable_rbp = options['disable-rbp'] || false
      disable_rubocop = options['disable-rubocop'] || false
      disable_reek = options['disable-reek'] || false

      clint = ClintEastwood::TheEnforcer.new(
        path,
        lint: options[:lint],
        disable_rbp: disable_rbp,
        disable_rubocop: disable_rubocop,
        disable_reek: disable_reek
      )

      # rubocop:disable Rails/Output
      abort('Linting Failed') unless clint.enforce
      puts 'Project passed the linter successfully'
      # rubocop:enable Rails/Output
    end
  end
end
