# frozen_string_literal: true

# User input processing
class Dispatcher
  # Add command to service
  # @param command [String] command name
  # @yield [raw_params] handler for command
  # @yieldparam raw_params [String] command params as string
  # @yieldreturn [String] command result
  def register(command, &block)
    entries[command] = block
  end

  # Extract command from raw string and calls handler
  # @param user_input [String] raw user input to handle
  # @return [String]
  def run(user_input)
    command, params = user_input.strip.split("\s", 2).map(&:strip)

    return unknown_command unless entries.key?(command)

    entries[command].call(params)
  end

  private

  def entries
    @entries ||= {}
  end

  def unknown_command
    "Command is unknown"
  end
end
