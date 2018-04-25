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
    # @return [String] section
    # @example
    #   puts "example".section #=>
    #   "┌──────────────────────────────────────────────────────────────────────────────────┐
    #    │ example                                                                          │
    #    └──────────────────────────────────────────────────────────────────────────────────┘"
    #
    #    "test".section color: :red #=>
    #    "┌──────────────────────────────────────────────────────────────────────────────────┐
    #     │ \e[0;31;49mtest\e[0m                                                             │
    #     └──────────────────────────────────────────────────────────────────────────────────┘"
    def section color: :none
      length = ( self.length > 80 ) ? self.length : 80
      message = ( color == :none ) ? self : self.colorize(color)

      sprintf "┌─%s─┐\n│ %-#{length+14}s │\n└─%s─┘\n", '─'*length, message, '─'*length
    end

    # return string representation as subsection
    #
    # @param color [Symbol] color of text
    # @return [String] subsection
    # @example
    #   puts "example".subsection #=> "| example"
    def subsection color: :none
      pipe = ( color == :none ) ? '|' : '|'.colorize(color)
      sprintf "%s %s", pipe, self
    end

    # add message output helpers to *Kernel*
    module ::Kernel
      # print section to stdout
      #
      # @param message [String] message to print in a section
      # @param color [Symbol] color of text
      # @example
      #   section "example"
      #   ┌──────────────────────────────────────────────────────────────────────────────────┐
      #   │ example                                                                          │
      #   └──────────────────────────────────────────────────────────────────────────────────┘
      #   #=> nil
      #
      #   section "example", color: red
      #   ┌──────────────────────────────────────────────────────────────────────────────────┐
      #   │ \e[0;31;49mtest\e[0m                                                             │
      #   └──────────────────────────────────────────────────────────────────────────────────┘
      #   #=> nil
      def section message, color: :none
        puts message.section(color: color)
      end

      # print subsection to stdout
      #
      # @param message [String] message to print in a subsection
      # @param color [Symbol] color of text
      # @example
      #   subsection "example" #=> nil
      #   | example
      def subsection message, color: :none
        puts message.subsection(color: color)
      end
    end
  end
end
