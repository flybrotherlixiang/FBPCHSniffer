#!/usr/bin/env ruby

require 'rubygems'
require 'commander/import'

program :name, 'FBPCHSniffer'
program :version, '0.0.1'
program :description, 'Find inappropriate header included in .pch file of your ObjC project.'

command :sniff do |c|
  c.syntax = 'FBPCHSniffer sniff [options]'
  c.summary = ''
  c.description = ''
  c.example 'description', 'command example'
  c.option '--some-switch', 'Some switch that does something'
  c.action do |args, options|
    # Do something or c.when_called Fbpchsniffer::Commands::Sniff
  end
end

