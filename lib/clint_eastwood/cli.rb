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
    option 'warn', type: :boolean

    default_task :lint

    desc 'lint', 'Lints the given project directory'
    def lint
      clint = load_and_configure

      # rubocop:disable Rails/Output
      if clint.enforce
        puts 'Project passed the linter successfully'
      else
        if options[:warn]
          puts 'Linting Failed'
        else
          abort('Linting Failed')
        end
      end
      # rubocop:enable Rails/Output
    end

    private

    # Lods and configures clint
    def load_and_configure
      path = options[:path] || File.expand_path('.')

      disable_rbp = options['disable-rbp'] || false
      disable_rubocop = options['disable-rubocop'] || false
      disable_reek = options['disable-reek'] || false

      ClintEastwood::TheEnforcer.new(
        path,
        lint: options[:lint],
        disable_rbp: disable_rbp,
        disable_rubocop: disable_rubocop,
        disable_reek: disable_reek
      )
    end
  end
end
