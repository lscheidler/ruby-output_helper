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

require "spec_helper"

describe OutputHelper do
  it "has a version number" do
    expect(OutputHelper::VERSION).not_to be nil
  end

  describe OutputHelper::Runtime do
    it "should return 2h 24m 50.2000s" do
      expect((2*60*60+24*60+50+0.2).runtime).to eq('2h 24m 50.2000s')
    end

    it "should return 2h 24m 50s" do
      expect((2*60*60+24*60+50).runtime).to eq('2h 24m 50s')
    end

    it "should return 2h 50s" do
      expect((2*60*60+50).runtime).to eq('2h 50s')
    end

    it "should return 24m" do
      expect((24*60).runtime).to eq('24m')
    end

    it "should return 24m 0.2000s" do
      expect((24*60 + 0.2).runtime).to eq('24m 0.2000s')
    end

    it "should return 24m 0.20s" do
      expect((24*60 + 0.2).runtime(precision: 2)).to eq('24m 0.20s')
    end

    it "should return 24m" do
      expect((24*60 + 0.224).runtime(precision: 0)).to eq('24m')
    end
  end

  describe OutputHelper::Message do
    describe String do
      it "should return a section" do
        expect("test".section).to match(/┌─{82}┐\n│ test {77}│\n└─{82}┘\n/)
      end

      it "should return a section with a customized box" do
        expect("test".section top_left: '#', top_right: '%', horizontal: '=', vertical: '|', bottom_left: '<', bottom_right: '>').to match(/#={82}%\n\| test {77}\|\n<={82}>\n/)
      end

      it "should return a red section" do
        expect("test".section(color: :red)).to match(/┌─{82}┐\n│ \e\[0;31;49mtest\e\[0m {77}│\n└─{82}┘\n/)
      end

      it "should return a subsection" do
        expect("test".subsection).to match(/\| test/)
      end

      it "should return a red subsection" do
        expect("test".subsection(color: :red)).to match(/\e\[0;31;49m\|\e\[0m test/)
      end

      it "should return a subsection with prefix" do
        expect("test".subsection prefix: '>>').to match(/>> test/)
      end

      it "should return a red subsection with prefix" do
        expect("test".subsection(color: :red, prefix: '>>')).to match(/\e\[0;31;49m\>>\e\[0m test/)
      end
    end

    describe Kernel do
      it "should output a section" do
        expect{section "test"}.to output(/┌─{82}┐\n│ test {77}│\n└─{82}┘\n/).to_stdout
      end

      it "should return a section with a customized box" do
        expect{section "test", top_left: '#', top_right: '%', horizontal: '=', vertical: '|', bottom_left: '<', bottom_right: '>'}.to output(/#={82}%\n\| test {77}\|\n<={82}>\n/).to_stdout
      end

      it "should output a red section" do
        expect{section "test", color: :red}.to output(/┌─{82}┐\n│ \e\[0;31;49mtest\e\[0m {77}│\n└─{82}┘\n/).to_stdout
      end

      it "should output a subsection" do
        expect{subsection "test"}.to output(/\| test\n/).to_stdout
      end

      it "should output a red subsection" do
        expect{subsection("test", color: :red)}.to output(/\e\[0;31;49m\|\e\[0m test\n/).to_stdout
      end

      it "should output a subsection with prefix" do
        expect{subsection "test", prefix: '>>'}.to output(/>> test\n/).to_stdout
      end

      it "should output a red subsection with prefix" do
        expect{subsection("test", color: :red, prefix: '>>')}.to output(/\e\[0;31;49m\>>\e\[0m test\n/).to_stdout
      end
    end
  end

  describe OutputHelper::Columns do
    before(:all) do
      @data = OutputHelper::Columns.new ["column1", "column2", "column3"]
      @data << ({column1: "test", column2: "testtesttest", column3: "test"})
    end

    it "should output an aligned table" do
      expect(@data.to_s).to eq(" column1 │ column2      │ column3 \n─────────┼──────────────┼─────────\n test    │ testtesttest │ test    \n")
    end

    it "should output an extended and aligned table" do
      @data << ({column1: "abcd", column3: "abcdabcdabcd", column2: "abcd"})
      expect(@data.to_s).to eq(" column1 │ column2      │ column3      \n─────────┼──────────────┼──────────────\n test    │ testtesttest │ test         \n abcd    │ abcd         │ abcdabcdabcd \n")
    end

    it "should iterate over all elements" do
      count = 0
      @data.each do |row|
        case count
        when 0
          expect(row).to eq({column1: "test", column2: "testtesttest", column3: "test"})
        when 1
          expect(row).to eq({column1: "abcd", column3: "abcdabcdabcd", column2: "abcd"})
        end
        count += 1
      end
    end

    describe 'formatter' do
      before(:all) do
        @data = OutputHelper::Columns.new ["column1", "column2", "column3"]
        @data.formatter :column2, Proc.new{|row, value| '<b>' + value + '</b>'}
        @data.formatter :column3, Proc.new{|row, value| value + ' (' + ((row[:column1] == value) ? 't' : 'f') + ')'}
        @data << ({column1: "test", column2: "testtesttest", column3: "test"})
        @data << ({column1: "abcd", column3: "abcdabcdabcd", column2: "abcd"})
      end

      it "should format output, if output formatter are set" do
        expect(@data.to_s).to eq(" column1 │ column2             │ column3          \n─────────┼─────────────────────┼──────────────────\n test    │ <b>testtesttest</b> │ test (t)         \n abcd    │ <b>abcd</b>         │ abcdabcdabcd (f) \n")
      end
    end
  end
end
