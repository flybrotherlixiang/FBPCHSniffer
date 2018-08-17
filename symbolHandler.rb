require 'colorize'

module Sniffer

  class SymbolHandler

    def self.get_undefined(objectFile)
      # puts 'getting undefined'
      absoluteObjFilePath = File.absolute_path objectFile

      cmdResult = `nm -ju #{absoluteObjFilePath}`
      # puts cmdResult.red
      return cmdResult.lines.map(&:chomp)
    end

    def self.get_defined(objectFile)
      # puts 'getting defined'
      absoluteObjFilePath = File.absolute_path objectFile

      cmdResult = `nm -jU #{absoluteObjFilePath}`
      # puts cmdResult.green
      return cmdResult.lines.map(&:chomp)
    end

  end

end
