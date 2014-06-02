require 'reek/cli/application'

# Ignores log and WorkerError::log commands in the reek line count
class Reek::Core::CodeParser
  def process_call(exp)
    (exp.method_name == :log) &&
      (!exp.receiver || exp.receiver.value == :WorkerError) &&
        @element.count_statements(-1)

    @element.record_call_to(exp)
    process_default(exp)
  end
end
