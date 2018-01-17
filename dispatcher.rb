
class Dispatcher

  def register(command, &block)
    entries[command] = block
  end

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
