# Copyright 2020 Lars Eric Scheidler
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'colorize'

module OutputHelper
  # columns output helper
  class Columns
    attr_reader :data

    @@separator         = '│'
    @@header_line       = '─'
    @@header_separator  = '┼'

    # configure columns output
    #
    # @param ascii [Bool] use only ascii characters for output
    # @param separator [String] set separater, which is used between columns
    # @param header_line [String] set character, which is used in header line to separate header and content
    # @param header_separator [String] set character, which is used between columns in header line
    def self.config ascii: nil, separator: nil, header_line: nil, header_separator: nil
      if not ascii.nil? and ascii
        @@separator         = '|'
        @@header_line       = '='
        @@header_separator  = '|'
      end

      @@separator         = separator unless separator.nil?
      @@header_line       = header_line unless header_line.nil?
      @@header_separator  = header_separator unless header_separator.nil?
    end

    # @param header [Array] list of columns
    def initialize header
      @max_length = header.map{|x| [x.to_sym, x.length]}.to_h
      @header     = header
      @data       = []
      @formatter  = {}
    end

    # add formatter for *key*
    #
    # @param key [Symbol] name of key to add formatter faro
    # @param block [Proc] Proc with two parameters
    # @example
    #   formatter :key, Proc.new{|row, value| '<b>' + value + '</b>'}
    #   formatter :key2, Proc.new{|row, value| value + ' (' + ((row[:key] == value) ? 't' : 'f') + ')'}
    def formatter key, block
      @formatter[key.to_sym] = block
    end

    # append new row
    #
    # @param row [Hash] hashmap with row to append
    def << row
      @max_length.each do |key, val|
        value = format_value row, key
        if value.is_a? String
          @max_length[key] = value.uncolorize.length if value.uncolorize.length > val
        else
          @max_length[key] = value.to_s.length if value.to_s.length > val
        end
      end
      @data << row
    end

    # Iterate over each element in Columns
    #
    # @yield [row] Calls the given block once for each element, passing that element as a parameter.
    def each
      @data.each do |row|
        yield row
      end
    end

    # returns aligned output of table
    #
    # @return [String] output
    def to_s
      result = ""

      separator = []
      result += @header.map do |key|
        separator << sprintf("%-#{@max_length[key.to_sym]}s", @@header_line*(@max_length[key.to_sym]+2))
        sprintf " %-#{@max_length[key.to_sym]}s ", key
      end.join(@@separator)
      result += "\n"
      result += separator.join(@@header_separator) + "\n"

      @data.each do |row|
        result += @header.map do |key|
          additional_width = 0
          value = format_value(row, key)
          if value.is_a? String
            additional_width = value.length - value.uncolorize.length
          end
          sprintf " %-#{@max_length[key.to_sym] + additional_width}s ", value
        end.join(@@separator)
        result += "\n"
      end
      result
    end

    # returns formatted value for *key*
    #
    # @param row [Hash] current row
    # @param key [Symbol] key for value to format
    # @return formatted value or value, if no formatter is set for key
    def format_value row, key
      key_sym = key.to_sym
      if @formatter.has_key? key_sym
        @formatter[key_sym].call row, row[key_sym]
      else
        row[key_sym]
      end
    end
  end
end
