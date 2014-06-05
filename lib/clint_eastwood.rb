require 'clint_eastwood/version'
require_relative 'better_reek.rb'
require 'pry'

# Clint Eastwood
module ClintEastwood

  # Lint enforcer
  class TheEnforcer
    @result = true

    def initialize(path, lint: nil, disable_reek: false, disable_rubocop: false, disable_rbp: false)
      gem_path = File.expand_path(File.dirname(__FILE__))
      @config_path = File.join(gem_path, '../config')

      @disable_rubocop = disable_rubocop
      @disable_reek = disable_reek
      @disable_rbp = disable_rbp

      @base_path = path
      @lint_paths = lint || %w(app lib config spec)
    end

    def enforce
      reek_result = @disable_reek || reek
      rubocop_result = @disable_rubocop || rubocop
      rbp_result = @disable_rbp || rails_best_practices

      reek_result && rubocop_result && rbp_result
    end

    def locate_config(filename)
      @user_config = File.join(@base_path, 'config', filename)
      @default_config = File.join(@config_path, filename)

      File.exist?(@user_config) ? @user_config : @default_config
    end

    def reek
      @reek_config = locate_config('reek.yml')

      reek_command = []

      @lint_paths.each do |path|
        reek_command << File.join(@base_path, path)
      end

      reek_command.concat ['--config', "#{@reek_config}"]

      # Reek returns the number of errors, so make sure it's zero
      Reek::Cli::Application.new(reek_command).execute == 0
    end

    def rubocop
      @rubocop_config = locate_config('rubocop.yml')

      paths = @lint_paths.map { |p| File.join(@base_path, p) }.join(' ')

      system "bundle exec rubocop --rails --config #{@rubocop_config} #{paths}"
    end

    def rails_best_practices
      system 'bundle exec rails_best_practices #{@lint_directory}'
    end
  end
end
