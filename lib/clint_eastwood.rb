require "clint_eastwood/version"
require_relative 'better_reek.rb'

module ClintEastwood
  class TheEnforcer
    @result = true

    def initialize(path)
      gem_path = File.expand_path(File.dirname(__FILE__))
      config_path = File.join(gem_path, '../config')

      @user_rubocop_config = File.join(path, 'config/rubocop.yml')
      @user_reek_config = File.join(path, 'config/reek.yml')
      @default_rubocop_config = File.join(config_path, 'rubocop.yml')
      @default_reek_config = File.join(config_path, 'reek.yml')

      @lint_path = path
      @rubocop_config = File.exist?(@user_rubocop_config) ? @user_rubocop_config : @default_rubocop_config
      @reek_config = File.exist?(@user_reek_config) ? @user_reek_config : @default_reek_config
    end

    def enforce
      reek_result = reek
      rubocop_result = rubocop
      rbp_result = rails_best_practices

      reek_result && rubocop_result && rbp_result
    end

    def reek
      puts
      puts '----------------------------------------------------------------'
      puts '----------------------------------------------------------------'
      puts 'Running reek'
      puts 
      puts "Using config: #{@reek_config}" if @user_reek_config == @reek_config
      puts "Using default config" if @default_reek_config == @reek_config
      puts '----------------------------------------------------------------'
      puts '----------------------------------------------------------------'
      puts

      Reek::Cli::Application.new(["#{@lint_path}/app", "#{@lint_path}/lib", "#{@lint_path}/config", "#{@lint_path}/spec", '--config', "#{@reek_config}"]).execute()
    end

    def rubocop
      puts
      puts '----------------------------------------------------------------'
      puts '----------------------------------------------------------------'
      puts 'Running rubocop'
      puts 
      puts "Using config: #{@rubocop_config}" if @user_rubocop_config == @rubocop_config
      puts "Using default config" if @default_rubocop_config == @rubocop_config

      puts '----------------------------------------------------------------'
      puts '----------------------------------------------------------------'
      puts

      system "bundle exec rubocop --rails --config #{@rubocop_config} #{@lint_path}/app #{@lint_path}/lib #{@lint_path}/config #{@lint_path}/spec"
    end

    def rails_best_practices
      puts
      puts '----------------------------------------------------------------'
      puts '----------------------------------------------------------------'
      puts 'Running rails_best_practices'
      puts '----------------------------------------------------------------'
      puts '----------------------------------------------------------------'
      puts

      system 'bundle exec rails_best_practices #{@lint_directory}'
    end
  end
end
