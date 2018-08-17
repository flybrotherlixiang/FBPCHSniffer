require 'logger'

module Sniffer

  def init_logger

    $logger = Logger.new(STDOUT)

  end
  module_function :init_logger

end
