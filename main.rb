#!/usr/bin/env ruby

$LOAD_PATH << '.'

require 'rubygems'
require 'commander/import'
require 'sniffer'
require 'Logger/logger'
require 'terminal-notifier'

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
    # c.option '--headerO STRING', String, 'Some switch that does something'
    # c.option '--sourceO STRING', String, 'Some switch that does something'
    c.action do |args, options|
      headerO = options.headerO
      sourceO = options.sourceO

      sniffer = Sniffer.new(headerO, sourceO)
      sniffer.sniff

      TerminalNotifier.notify('finish sniffing', :title => 'PCHSniffer')
    end
  end

  command :test do |c|
    c.action do |args, options|
      unqualifiedHeaders = ["foo.c", "bar.m"]
      unqualifiedHeaderRates = [10, 15]
      unqualifiedHeaders.each_with_index do |unqualifiedHeader, index|
        puts unqualifiedHeader.red
        puts ("#{unqualifiedHeaderRates[index]} %").red
      end
    end
  end

end
