$LOAD_PATH << '.'

require 'symbolHandler'
require 'colorize'

module Sniffer

  class Sniffer

    attr_accessor :headerO, :sourceO

    def initialize(headerO, sourceO)
      @headerO = headerO
      @sourceO = sourceO
    end

    def sniff
      headerObjectFiles = [
        # "/Users/jakeli/Library/Developer/Xcode/DerivedData/QQMSFContact-eybkhozubmrualfrofgseypggvxs/Build/Intermediates.noindex/Contacts.build/Debug-iphonesimulator/Contacts.build/Objects-normal/x86_64/QQPimConst.o",
        # "/Users/jakeli/Library/Developer/Xcode/DerivedData/QQMSFContact-eybkhozubmrualfrofgseypggvxs/Build/Intermediates.noindex/Contacts.build/Debug-iphonesimulator/Contacts.build/Objects-normal/x86_64/QQContactsContactListViewController.o"

        "/Users/jakeli/Library/Developer/Xcode/DerivedData/QQMSFContact-eybkhozubmrualfrofgseypggvxs/Build/Intermediates.noindex/QQMainProject.build/Debug-iphonesimulator/QQMainProject.build/Objects-normal/x86_64/MSFImagePool.o",
        "/Users/jakeli/Library/Developer/Xcode/DerivedData/QQMSFContact-eybkhozubmrualfrofgseypggvxs/Build/Intermediates.noindex/QQMainProject.build/Debug-iphonesimulator/QQMainProject.build/Objects-normal/x86_64/Logger.o",
        "/Users/jakeli/Library/Developer/Xcode/DerivedData/QQMSFContact-eybkhozubmrualfrofgseypggvxs/Build/Intermediates.noindex/QQMainProject.build/Debug-iphonesimulator/QQMainProject.build/Objects-normal/x86_64/UIViewControllerAdditions.o",
        "/Users/jakeli/Library/Developer/Xcode/DerivedData/QQMSFContact-eybkhozubmrualfrofgseypggvxs/Build/Intermediates.noindex/QQMainProject.build/Debug-iphonesimulator/QQMainProject.build/Objects-normal/x86_64/QDevice.o",
        "/Users/jakeli/Library/Developer/Xcode/DerivedData/QQMSFContact-eybkhozubmrualfrofgseypggvxs/Build/Intermediates.noindex/QQMainProject.build/Debug-iphonesimulator/QQMainProject.build/Objects-normal/x86_64/QQDynamicDeviceInfo.o",
        "/Users/jakeli/Library/Developer/Xcode/DerivedData/QQMSFContact-eybkhozubmrualfrofgseypggvxs/Build/Intermediates.noindex/QQMainProject.build/Debug-iphonesimulator/QQMainProject.build/Objects-normal/x86_64/QQBinaryPlistAddition.o",
        "/Users/jakeli/Library/Developer/Xcode/DerivedData/QQMSFContact-eybkhozubmrualfrofgseypggvxs/Build/Intermediates.noindex/QQMainProject.build/Debug-iphonesimulator/QQMainProject.build/Objects-normal/x86_64/QQThread+runMode.h.o",
        "/Users/jakeli/Library/Developer/Xcode/DerivedData/QQMSFContact-eybkhozubmrualfrofgseypggvxs/Build/Intermediates.noindex/QQMainProject.build/Debug-iphonesimulator/QQMainProject.build/Objects-normal/x86_64/QQThread+runMode.h.o"

      ]

      # sourceObjectFiles = [
      #   # "/Users/jakeli/Library/Developer/Xcode/DerivedData/QQMSFContact-eybkhozubmrualfrofgseypggvxs/Build/Intermediates.noindex/Contacts.build/Debug-iphonesimulator/Contacts.build/Objects-normal/x86_64/QQPimEngine.o",
      #   "/Users/jakeli/Library/Developer/Xcode/DerivedData/QQMSFContact-eybkhozubmrualfrofgseypggvxs/Build/Intermediates.noindex/Contacts.build/Debug-iphonesimulator/Contacts.build/Objects-normal/x86_64/QQPimEngineAccountService.o",

      #   "/Users/jakeli/Library/Developer/Xcode/DerivedData/QQMSFContact-eybkhozubmrualfrofgseypggvxs/Build/Intermediates.noindex/Contacts.build/Debug-iphonesimulator/Contacts.build/Objects-normal/x86_64/QQContactBindingViewController.o",
      #   "/Users/jakeli/Library/Developer/Xcode/DerivedData/QQMSFContact-eybkhozubmrualfrofgseypggvxs/Build/Intermediates.noindex/Contacts.build/Debug-iphonesimulator/Contacts.build/Objects-normal/x86_64/QQContactsFillVerifyCodeViewController.o"
      # ]

      sourceObjectFiles = get_source_files

      symbolDependencyInfosMapping = Hash.new
      headerObjectFiles.each { |headerObjectFile|
        symbolDependencyInfos = []
        sourceObjectFiles.each { |sourceObjectFile|
          symbolDependencyInfo = SymbolDependencyInfo.new
          symbolDependencyInfo.fileName = File.basename(sourceObjectFile)
          symbolDependencyInfo.fileFullPath = sourceObjectFile
          referencedSymbols = checkRelation(headerObjectFile, sourceObjectFile)
          if referencedSymbols.count == 0
            next
          end

          symbolDependencyInfo.referencedSymbols = referencedSymbols
          symbolDependencyInfos.push(symbolDependencyInfo)
        }

        symbolDependencyInfosMapping[headerObjectFile] = symbolDependencyInfos
      }

      print_summary(symbolDependencyInfosMapping, sourceObjectFiles)

      # puts get_source_files.count
      # $logger.fatal '123321 logger fatal'.red
    end

    #private :sniff

    # return an array of referenced symbols from headerObjectFile to targetObjectFile
    def checkRelation(headerObjectFile, targetObjectFile)
      targetUndefinedSymbols = SymbolHandler.get_undefined targetObjectFile
      headerDefinedSymbols = SymbolHandler.get_defined headerObjectFile
      intersections = headerDefinedSymbols & targetUndefinedSymbols
      # puts "intersections are #{intersections}".light_blue
      return intersections
    end
    private :checkRelation

    def print_summary(symbolDependencyInfosMapping, sourceObjectFiles)
      unqualifiedHeaders = []
      unqualifiedHeaderRates = []
      symbolDependencyInfosMapping.each do |headerObjectFile, infos|
        puts ">>>>>>>>>>>>Showing dependency of #{headerObjectFile}:".yellow

        rate = (1.0 * infos.count / sourceObjectFiles.count * 100).round(2)
        puts "referenced by #{infos.count} file in #{sourceObjectFiles.count} #{rate}%".green
        infos.each { |info|
          puts "referer:".light_blue
          puts "name: #{info.fileFullPath}".light_blue
          puts "#{info.referencedSymbols.count} symbols used: #{info.referencedSymbols}".light_blue
        }

        if rate < 10
          unqualifiedHeaders.push headerObjectFile
          unqualifiedHeaderRates.push rate
        end

        puts
      end

      puts "unqualified headers:".red
      unqualifiedHeaders.each_with_index do |unqualifiedHeader, index|
        puts unqualifiedHeader.red
        puts ("#{unqualifiedHeaderRates[index]} %").red
        puts
      end
    end
    private :print_summary

    def get_source_files
      cmdResult = `find /Users/jakeli/Library/Developer/Xcode/DerivedData/QQMSFContact-eybkhozubmrualfrofgseypggvxs/Build/Intermediates.noindex/QQMainProject.build/Debug-iphonesimulator/QQMainProject.build/Objects-normal/x86_64/ -name "*.o"`
      return cmdResult.lines.map(&:chomp)
    end
    private :get_source_files

  end

  # SymbolDependencyInfo remembers the relation of a header file and all the files that referenced it symbols when linking
  #
  # :fileName => file name
  # :fileFullPath => file full path
  # :referencedSymbols => referenced symbols
  class SymbolDependencyInfo
    attr_accessor :fileName, :fileFullPath, :referencedSymbols
  end

end
