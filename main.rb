
require_relative 'init'

dispatcher = init

dispatcher.register("exit") { throw(:exit) }

catch(:exit) do
  loop do
    print "> "
    command = readline
    puts dispatcher.run(command)
  end
end