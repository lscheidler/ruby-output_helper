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

module OutputHelper
  # runtime output helpers
  module Runtime
    # return runtime as string (1h 4m 4s)
    #
    # @param precision [Fixnum] miliseconds precision
    def runtime precision: 4
      result = []
      if (hours = self/60/60).to_i > 0
        result << sprintf("%ih", hours)
      end
      if (minutes = self/60%60).to_i >0
        result << sprintf("%im", minutes)
      end
      if (seconds = self%60%60) > 0 and (seconds-seconds.to_i) > 0 and precision > 0
        result << sprintf("%.#{precision}fs", seconds)
      elsif seconds.to_i > 0
        result << sprintf("%is", seconds)
      end
      result.join(" ")
    end
  end
end
