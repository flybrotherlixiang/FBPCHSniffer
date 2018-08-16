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
        "/Users/jakeli/Library/Developer/Xcode/DerivedData/QQMSFContact-eybkhozubmrualfrofgseypggvxs/Build/Intermediates.noindex/Contacts.build/Debug-iphonesimulator/Contacts.build/Objects-normal/x86_64/QQPimConst.o",
        "/Users/jakeli/Library/Developer/Xcode/DerivedData/QQMSFContact-eybkhozubmrualfrofgseypggvxs/Build/Intermediates.noindex/Contacts.build/Debug-iphonesimulator/Contacts.build/Objects-normal/x86_64/QQContactsContactListViewController.o"
      ]

      sourceObjectFiles = [
        "/Users/jakeli/Library/Developer/Xcode/DerivedData/QQMSFContact-eybkhozubmrualfrofgseypggvxs/Build/Intermediates.noindex/Contacts.build/Debug-iphonesimulator/Contacts.build/Objects-normal/x86_64/QQPimEngine.o",
        "/Users/jakeli/Library/Developer/Xcode/DerivedData/QQMSFContact-eybkhozubmrualfrofgseypggvxs/Build/Intermediates.noindex/Contacts.build/Debug-iphonesimulator/Contacts.build/Objects-normal/x86_64/QQPimEngineAccountService.o",

        "/Users/jakeli/Library/Developer/Xcode/DerivedData/QQMSFContact-eybkhozubmrualfrofgseypggvxs/Build/Intermediates.noindex/Contacts.build/Debug-iphonesimulator/Contacts.build/Objects-normal/x86_64/QQContactBindingViewController.o",
        "/Users/jakeli/Library/Developer/Xcode/DerivedData/QQMSFContact-eybkhozubmrualfrofgseypggvxs/Build/Intermediates.noindex/Contacts.build/Debug-iphonesimulator/Contacts.build/Objects-normal/x86_64/QQContactsFillVerifyCodeViewController.o"
      ]


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

      pretty_print_dependency_infos symbolDependencyInfosMapping
      # checkRelation(@headerO, @sourceO)
      # $logger.fatal '123321 logger fatal'.red
    end

    #private :sniff

    # return an array of referenced symbols from headerObjectFile to targetObjectFile
    def checkRelation(headerObjectFile, targetObjectFile)
      targetUndefinedSymbols = SymbolHandler.get_undefined targetObjectFile
      # puts sourceUndefinedSymbols
      # sourceUndefinedSymbols = sourceUndefinedSymbols.lines.map(&:chomp)
      # puts sourceUndefinedSymbols.count
      # puts sourceUndefinedSymbols
      # sourceUndefinedSymbols = ["123", "333", "456"]

      headerDefinedSymbols = SymbolHandler.get_defined headerObjectFile
      # puts sourceDefinedSymbols
      # sourceDefinedSymbols = sourceDefinedSymbols.lines.map(&:chomp)
      # puts sourceDefinedSymbols.count
      # puts sourceDefinedSymbols
      # sourceDefinedSymbols = ["123", "444", "456"]

      intersections = headerDefinedSymbols & targetUndefinedSymbols
      puts "intersections are #{intersections}".light_blue
      return intersections
    end
    private :checkRelation

    def pretty_print_dependency_infos(symbolDependencyInfosMapping)
      symbolDependencyInfosMapping.each do |headerObjectFile, infos|
        # puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>".yellow
        puts ">>>>>>>>>>>>Showing dependency of #{headerObjectFile}:".yellow
        puts "referenced by #{infos.count} file".green
        infos.each { |info|
          puts "referer: #{info.fileFullPath}".light_blue
        }
      end
    end
    private :pretty_print_dependency_infos

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
