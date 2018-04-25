# OutputHelper

Provides output helpers

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'execute', git: 'https://github.com/lscheidler/ruby-output_helper'
```

And then execute:

    $ bundle

## Usage

### Pretty print runtime

```ruby
require 'bundler/setup'
require 'output_helper'

puts Benchmark.realtime{sleep 1.2}.runtime
1.2007s
=> nil
```

### Print section

```ruby
puts "test".section
┌──────────────────────────────────────────────────────────────────────────────────┐
│ test                                                                             │
└──────────────────────────────────────────────────────────────────────────────────┘
=> nil

puts "test".section top_left: '[', top_right: ']', horizontal: '=', vertical: '|', bottom_left: '<', bottom_right: '>'
[==================================================================================]
| Test                                                                             |
<==================================================================================>
=> nil

section "test"
┌──────────────────────────────────────────────────────────────────────────────────┐
│ test                                                                             │
└──────────────────────────────────────────────────────────────────────────────────┘
=> nil

section "test", top_left: '[', top_right: ']', horizontal: '=', vertical: '|', bottom_left: '<', bottom_right: '>'
[==================================================================================]
| Test                                                                             |
<==================================================================================>
=> nil
```

### Print colored section

```ruby
puts "test".section(color: :red)
┌──────────────────────────────────────────────────────────────────────────────────┐
│ \e[0;31;49mtest\e[0m                                                             │
└──────────────────────────────────────────────────────────────────────────────────┘
=> nil

section "test", color: :red
┌──────────────────────────────────────────────────────────────────────────────────┐
│ \e[0;31;49mtest\e[0m                                                             │
└──────────────────────────────────────────────────────────────────────────────────┘
=> nil
```

### Print subsection

```ruby
puts "test".subsection
| test
=> nil

puts "test".subsection(prefix: '>>')
>> test
=> nil

subsection "test"
| test
=> nil

subsection "test", prefix: '>>'
>> test
=> nil
```

### Print colored section

```ruby
puts "test".subsection(color: :red)
\e[0;31;49m|\e[0m test
=> nil

puts "test".subsection(color: :red, prefix: '>>')
\e[0;31;49m>>\e[0m test
=> nil

subsection "test", color: :red
\e[0;31;49m|\e[0m test
=> nil

subsection "test", color: :red, prefix: '>>'
\e[0;31;49m>>\e[0m test
=> nil
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lscheidler/output_helper.


## License

The gem is available as open source under the terms of the [Apache 2.0 License](http://opensource.org/licenses/Apache-2.0).

