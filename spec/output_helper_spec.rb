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
        expect("test".section).to match(/┌─+┐\n│ test +│\n└─+┘\n/)
      end

      it "should return a red section" do
        expect("test".section(color: :red)).to match(/┌─+┐\n│ \e\[0;31;49mtest\e\[0m +│\n└─+┘\n/)
      end

      it "should return a subsection" do
        expect("test".subsection).to match(/\| test/)
      end

      it "should return a red subsection" do
        expect("test".subsection(color: :red)).to match(/\e\[0;31;49m\|\e\[0m test/)
      end
    end

    describe Kernel do
      it "should output a section" do
        expect{section "test"}.to output(/┌─+┐\n│ test +│\n└─+┘\n/).to_stdout
      end

      it "should output a red section" do
        expect{section "test", color: :red}.to output(/┌─+┐\n│ \e\[0;31;49mtest\e\[0m +│\n└─+┘\n/).to_stdout
      end

      it "should output a subsection" do
        expect{subsection "test"}.to output(/\| test\n/).to_stdout
      end

      it "should output a red subsection" do
        expect{subsection("test", color: :red)}.to output(/\e\[0;31;49m\|\e\[0m test\n/).to_stdout
      end
    end
  end
end
