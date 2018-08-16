#!/usr/bin/env ruby

$LOAD_PATH << '.'

require 'rubygems'
require 'commander/import'
require 'sniffer'
require 'Logger/logger'

module Sniffer

  init_logger

  program :name, 'FBPCHSniffer'
  program :version, '0.0.1'
  program :description, 'Find inappropriate header included in .pch file of your ObjC project.'

  command :sniff do |c|
    c.syntax = 'FBPCHSniffer sniff [options]'
    c.summary = ''
    c.description = ''
    c.example 'description', 'command example'
    c.option '--headerO STRING', String, 'Some switch that does something'
    c.option '--sourceO STRING', String, 'Some switch that does something'
    c.action do |args, options|
      headerO = options.headerO
      sourceO = options.sourceO
      puts "header are #{headerO}"
      puts "source are #{sourceO}"

      sniffer = Sniffer.new(headerO, sourceO)
      sniffer.sniff
      # Do something or c.when_called Fbpchsniffer::Commands::Sniff
    end
  end

end
