require 'rails_best_practices/core/runner'

# Rails best practices
module RailsBestPractices
  # RBP Core
  module Core
    #RBP Runner
    class Runner
      # initialize the runner.
      #
      # @param [Hash] options pass the prepares and reviews.
      def initialize(options={})
        gem_path = File.expand_path(File.dirname(__FILE__))
        default_config_path = File.join(gem_path, '../config/rails_best_practices.yml')

        custom_config = File.join(Runner.base_path, 'config/rails_best_practices.yml')
        @config = File.exists?(custom_config) ? custom_config : default_config_path

        lexicals = Array(options[:lexicals])
        prepares = Array(options[:prepares])
        reviews = Array(options[:reviews])

        checks_loader = ChecksLoader.new(@config)
        @lexicals = lexicals.empty? ? checks_loader.load_lexicals : lexicals
        @prepares = prepares.empty? ? load_prepares : prepares
        @reviews = reviews.empty? ? checks_loader.load_reviews : reviews
        load_plugin_reviews if reviews.empty?

        @lexical_checker ||= CodeAnalyzer::CheckingVisitor::Plain.new(checkers: @lexicals)
        @plain_prepare_checker ||= CodeAnalyzer::CheckingVisitor::Plain.new(checkers: @prepares.select { |checker| checker.is_a? Prepares::GemfilePrepare })
        @default_prepare_checker ||= CodeAnalyzer::CheckingVisitor::Default.new(checkers: @prepares.select { |checker| !checker.is_a? Prepares::GemfilePrepare })
        @review_checker ||= CodeAnalyzer::CheckingVisitor::Default.new(checkers: @reviews)
      end
    end
  end
end