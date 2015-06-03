require 'clint_eastwood/version'
require 'rails_best_practices'
require_relative 'better_reek.rb'
require_relative 'better_rails_best_practices.rb'

# Clint Eastwood
module ClintEastwood

  # Lint enforcer
  class TheEnforcer
    @result = true

    # Initializes a new Enforce Object with the desired settings
    #
    # @param path [String] The base path to lint
    # @param lint [Array<String>] The desired subdirectories to lint (defaults to ['app', 'lib', 'config', 'spec'])
    # @param disable_reek [Boolean] If true, this stops reek from running
    # @param disable_rubocop [Boolean] If true, this stops rubocop from running
    # @param disable_rbp [Boolean] If true, this stops rails best practices from running
    #
    # @returns [TheEnforcer] A new enforcer object
    def initialize(path, lint: nil, disable_reek: false, disable_rubocop: false, disable_rbp: false)
      gem_path = File.expand_path(File.dirname(__FILE__))
      @config_path = File.join(gem_path, '../config')

      @disable_rubocop = disable_rubocop
      @disable_reek = disable_reek
      @disable_rbp = disable_rbp

      @base_path = path
      @lint_paths = lint || %w(app lib config spec)
    end

    # Runs each desired linting gem with the appropriate settings
    # @returns [Boolean] Whether or not the linters were all successfuls
    def enforce
      reek_result = @disable_reek || reek
      rubocop_result = @disable_rubocop || rubocop
      rbp_result = @disable_rbp || rails_best_practices

      reek_result && rubocop_result && rbp_result
    end

    private

    def locate_config(filename)
      @user_config = File.join(@base_path, 'config', filename)
      @default_config = File.join(@config_path, filename)

      File.exist?(@user_config) ? @user_config : @default_config
    end

    # Run reek
    def reek
      @reek_config = locate_config('reek.yml')

      reek_command = []

      @lint_paths.each do |path|
        reek_command << File.join(@base_path, path)
      end

      reek_command.concat ['--config', "#{@reek_config}"]

      # Reek returns the number of errors, so make sure it's zero
      Reek::CLI::Application.new(reek_command).execute == 0
    end

    # Run rubocop
    def rubocop
      @rubocop_config = locate_config('rubocop.yml')

      paths = @lint_paths.map { |p| File.join(@base_path, p) }.join(' ')

      system "bundle exec rubocop --rails --config #{@rubocop_config} #{paths}"
    end

    # Run rails best practices
    def rails_best_practices
      options = {}
      analyzer = RailsBestPractices::Analyzer.new(@base_path)
      analyzer.analyze
      analyzer.output
      analyzer.runner.errors.size == 0
    end
  end
end
