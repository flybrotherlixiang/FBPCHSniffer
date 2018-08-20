# FBPCHSniffer
An command line tool to find abused `.pch` dependency in iOS project

## Installation

Install ruby gems 

```shell
bundle install
```

## Usage

- build your project
- locate the `.o` files to be examined
- implement `get_header_files` and `get_source_files` in `sniffer.rb`
- then run:
```shell
ruby main.rb sniff
```

## Architecture
![](https://github.com/flybrotherlixiang/FBPCHSniffer/blob/master/docs/FBPCHSniffer.png?raw=true)

## Todo
- reads header `.o` files from `.pch`
- reads source `.o` files from `.xcodeproj`
