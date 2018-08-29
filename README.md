# OutputHelper

[![Build Status](https://travis-ci.org/lscheidler/ruby-output_helper.svg?branch=master)](https://travis-ci.org/lscheidler/ruby-output_helper)

Provides output helpers

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'execute', git: 'https://github.com/lscheidler/ruby-output_helper'
```

And then execute:

    $ bundle

## Usage

### Configuration

```ruby
OutputHelper::Message.config ascii: true

puts "example".section
====================================================================================
# example                                                                          #
====================================================================================

OutputHelper::Message.config section_horizontal: '-', section_vertical: '='

puts "example".section
=----------------------------------------------------------------------------------=
= example                                                                          =
=----------------------------------------------------------------------------------=
=> nil

OutputHelper::Message.config section_color: :red

puts "test".section
=----------------------------------------------------------------------------------=
= \e[0;31;49mtest\e[0m                                                             =
=----------------------------------------------------------------------------------=
=> nil
```

| config name             | description                           |
|-------------------------|---------------------------------------|
| ascii                   | use only ascii characters for output  |
| section\_color          | color of text                         |
| section\_top\_left      | top left corner of box                |
| section\_horizontal     | character for horizontal line         |
| section\_top\_right     | top right corner of box               |
| section\_vertical       | character for vertical line           |
| section\_bottom\_left   | bottom left corner of box             |
| section\_bottom\_right  | bottom right corner of box            |
| subsection\_color       | color of text                         |
| subsection\_prefix      | prefix to use for subsection          |

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

### Columns

```ruby
table = OutputHelper::Columns.new ['name', 'description']
table << ({name: 'ant', description: 'insect'})
table << ({name: 'elephant', description: 'mammalian'})
puts table
 name     │ description 
──────────┼─────────────
 ant      │ insect      
 elephant │ mammalian   

OutputHelper::Columns.config ascii: true

puts table
 name     | description 
==========|=============
 ant      | insect      
 elephant | mammalian   
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lscheidler/output_helper.


## License

The gem is available as open source under the terms of the [Apache 2.0 License](http://opensource.org/licenses/Apache-2.0).

