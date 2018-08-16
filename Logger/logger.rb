require 'logger'

module Sniffer

  def init_logger

    $logger = Logger.new(STDOUT)
    puts "logger is #$l"

  end
  module_function :init_logger

end
