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
    def section color: :none, top_left: '┌', horizontal: '─', top_right: '┐', vertical: '│', bottom_left: '└', bottom_right: '┘'
      length = ( self.length > 80 ) ? self.length : 80
      message = ( color == :none ) ? self : self.colorize(color)

      result = ""
      result += top_left + horizontal*(length+2) + top_right + "\n"
      result += sprintf "%s %-#{length+((message.colorized?) ? 14 : 0)}s %s\n", vertical, message, vertical
      result += bottom_left + horizontal*(length+2) + bottom_right + "\n"
    end

    # return string representation as subsection
    #
    # @param color [Symbol] color of text
    # @param prefix [String] prefix to use for subsection
    # @return [String] subsection
    # @example
    #   puts "example".subsection #=> "| example"
    def subsection color: :none, prefix: '|'
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
      def section message, color: :none, top_left: '┌', horizontal: '─', top_right: '┐', vertical: '│', bottom_left: '└', bottom_right: '┘'
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
      def subsection message, color: :none, prefix: '|'
        ::Kernel::puts message.subsection(color: color, prefix: prefix)
      end
    end
  end
end
