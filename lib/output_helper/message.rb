# Copyright 2018 Lars Eric Scheidler
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
  # message output helper
  module Message
    @@section_color         = :none
    @@section_top_left      = '┌'
    @@section_horizontal    = '─'
    @@section_top_right     = '┐'
    @@section_vertical      = '│'
    @@section_bottom_left   = '└'
    @@section_bottom_right  = '┘'
    @@subsection_color      = :none
    @@subsection_prefix     = '|'

    # configure section and subsection output globally
    #
    # @param ascii [Bool] use only ascii characters for output
    # @param section_color [Symbol] color of text
    # @param section_top_left [String] top left corner of box
    # @param section_horizontal [String] character for horizontal line
    # @param section_top_right [String] top right corner of box
    # @param section_vertical [String] character for vertical line
    # @param section_bottom_left [String] bottom left corner of box
    # @param section_bottom_right [String] bottom right corner of box
    # @param subsection_color [Symbol] color of text
    # @param subsection_prefix [String] prefix to use for subsection
    # @example
    #   OutputHelper::Message.config ascii: true
    #
    #   puts "example".section
    #   ====================================================================================
    #   # example                                                                          #
    #   ====================================================================================
    #
    #   OutputHelper::Message.config section_horizontal: '-', section_vertical: '='
    #
    #   puts "example".section
    #   =----------------------------------------------------------------------------------=
    #   = example                                                                          =
    #   =----------------------------------------------------------------------------------=
    #   => nil
    def self.config ascii: nil,
                    section_color: nil,
                    section_top_left: nil,
                    section_horizontal: nil,
                    section_top_right: nil,
                    section_vertical: nil,
                    section_bottom_left: nil,
                    section_bottom_right: nil,
                    subsection_color: nil,
                    subsection_prefix: nil
      if not ascii.nil? and ascii
        @@section_top_left      = '='
        @@section_horizontal    = '='
        @@section_top_right     = '='
        @@section_vertical      = '#'
        @@section_bottom_left   = '='
        @@section_bottom_right  = '='
        @@subsection_prefix     = '|'
      end

      @@section_color         = section_color unless section_color.nil?
      @@section_top_left      = section_top_left unless section_top_left.nil?
      @@section_horizontal    = section_horizontal unless section_horizontal.nil?
      @@section_top_right     = section_top_right unless section_top_right.nil?
      @@section_vertical      = section_vertical unless section_vertical.nil?
      @@section_bottom_left   = section_bottom_left unless section_bottom_left.nil?
      @@section_bottom_right  = section_bottom_right unless section_bottom_right.nil?
      @@subsection_color      = subsection_color unless subsection_color.nil?
      @@subsection_prefix     = subsection_prefix unless subsection_prefix.nil?
    end

    # returns configuration *name*
    #
    # @param name [Symbol] name of configuration
    # @return [Object] configuration *name*
    def self.config_get name
      if class_variable_defined? "@@#{name}"
        class_variable_get "@@#{name}"
      end
    end

    # return string representation as section
    #
    # @param color [Symbol] color of text
    # @param top_left [String] top left corner of box
    # @param horizontal [String] character for horizontal line
    # @param top_right [String] top right corner of box
    # @param vertical [String] character for vertical line
    # @param bottom_left [String] bottom left corner of box
    # @param bottom_right [String] bottom right corner of box
    # @return [String] section
    # @example
    #   puts "example".section
    #   "┌──────────────────────────────────────────────────────────────────────────────────┐
    #    │ example                                                                          │
    #    └──────────────────────────────────────────────────────────────────────────────────┘"
    #   => nil
    #
    #   puts "example".section top_left: "[", top_right: ']', bottom_left: '<', bottom_right: ">", vertical: "|", horizontal: "="
    #   [==================================================================================]
    #   | example                                                                          |
    #   <==================================================================================>
    #   => nil
    #
    #   "test".section color: :red
    #   "┌──────────────────────────────────────────────────────────────────────────────────┐
    #    │ \e[0;31;49mtest\e[0m                                                             │
    #    └──────────────────────────────────────────────────────────────────────────────────┘"
    #   => nil
    def section color: @@section_color,
                top_left: @@section_top_left,
                horizontal: @@section_horizontal,
                top_right: @@section_top_right,
                vertical: @@section_vertical,
                bottom_left: @@section_bottom_left,
                bottom_right: @@section_bottom_right
      length = ( self.length > 80 ) ? self.length : 80
      message = ( color == :none ) ? self : self.colorize(color)

      additional_width = message.length - message.uncolorize.length

      result = ""
      result += top_left + horizontal*(length+2) + top_right + "\n"
      result += sprintf "%s %-#{length+additional_width}s %s\n", vertical, message, vertical
      result += bottom_left + horizontal*(length+2) + bottom_right + "\n"
    end

    # return string representation as subsection
    #
    # @param color [Symbol] color of text
    # @param prefix [String] prefix to use for subsection
    # @return [String] subsection
    # @example
    #   puts "example".subsection #=> "| example"
    def subsection color: @@subsection_color, prefix: @@subsection_prefix
      pipe = ( color == :none ) ? prefix : prefix.colorize(color)
      sprintf "%s %s", pipe, self
    end

    # add message output helpers to *Kernel*
    module ::Kernel
      # print section to stdout
      #
      # @param message [String] message to print in a section
      # @param color [Symbol] color of text
      # @param top_left [String] top left corner of box
      # @param horizontal [String] character for horizontal line
      # @param top_right [String] top right corner of box
      # @param vertical [String] character for vertical line
      # @param bottom_left [String] bottom left corner of box
      # @param bottom_right [String] bottom right corner of box
      # @example
      #   section "example"
      #   ┌──────────────────────────────────────────────────────────────────────────────────┐
      #   │ example                                                                          │
      #   └──────────────────────────────────────────────────────────────────────────────────┘
      #   => nil
      #
      #   section "example", top_left: "[", top_right: ']', bottom_left: '<', bottom_right: ">", vertical: "|", horizontal: "="
      #   [==================================================================================]
      #   | example                                                                          |
      #   <==================================================================================>
      #   => nil
      #
      #   section "example", color: red
      #   ┌──────────────────────────────────────────────────────────────────────────────────┐
      #   │ \e[0;31;49mtest\e[0m                                                             │
      #   └──────────────────────────────────────────────────────────────────────────────────┘
      #   => nil
      def section message,  color: OutputHelper::Message.config_get(:section_color),
                            top_left: OutputHelper::Message.config_get(:section_top_left),
                            horizontal: OutputHelper::Message.config_get(:section_horizontal),
                            top_right: OutputHelper::Message.config_get(:section_top_right),
                            vertical: OutputHelper::Message.config_get(:section_vertical),
                            bottom_left: OutputHelper::Message.config_get(:section_bottom_left),
                            bottom_right: OutputHelper::Message.config_get(:section_bottom_right)
        ::Kernel::puts message.section(color: color, top_left: top_left, horizontal: horizontal, top_right: top_right, vertical: vertical, bottom_left: bottom_left, bottom_right: bottom_right)
      end

      # print subsection to stdout
      #
      # @param message [String] message to print in a subsection
      # @param color [Symbol] color of text
      # @param prefix [String] prefix to use for subsection
      # @example
      #   subsection "example" #=> nil
      #   | example
      def subsection message, color: OutputHelper::Message.config_get(:subsection_color), prefix: OutputHelper::Message.config_get(:subsection_prefix)
        ::Kernel::puts message.subsection(color: color, prefix: prefix)
      end
    end
  end
end
