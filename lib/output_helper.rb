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

require "output_helper/version"

require "output_helper/message"
require "output_helper/runtime"

module OutputHelper
  # include *Runtime* helpers into *Fixnum*
  class ::Fixnum
    include Runtime
  end

  # include *Runtime* helpers into *Float*
  class ::Float
    include Runtime
  end

  # include *Runtime* helpers into *Integer*
  class ::Integer
    include Runtime
  end

  # include *Message* helpers into *String*
  class ::String
    include Message
  end
end
