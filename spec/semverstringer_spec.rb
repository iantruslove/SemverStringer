require 'semverstringer/semver'

describe Semverstringer::Semver do
	describe "parameterless construction" do
		it "can be initialized with no parameters" do 
			semver = Semverstringer::Semver.new 
		end

		it "will output a default version string" do
			semver = Semverstringer::Semver.new 
			semver.to_s.should == "0.0.1"
		end
	end

	describe "parameterized construction" do
		it "can be constructed with integer parameter for major version" do
			semver = Semverstringer::Semver.new :major => 1
			semver.to_s.should == "1.0.0"
		end

		it "can be constructed with integer parameter for minor version" do
			semver = Semverstringer::Semver.new :minor => 2
			semver.to_s.should == "0.2.0"
		end

		it "can be constructed with integer parameter for patch version" do
			semver = Semverstringer::Semver.new :patch => 23
			semver.to_s.should == "0.0.23"
		end

		it "can be constructed with combinations of major, minor and patch versions" do
			semver = Semverstringer::Semver.new :major=>2, :minor=>4, :patch=>20
			semver.to_s.should == "2.4.20"
		end
	end


	describe "invalid initialization values" do
		it "should only allow positive version number components" do
			lambda { Semverstringer::Semver.new :minor=>-1 }.should raise_error(ArgumentError)
		end

		it "should only allow numeric version number components" do
			lambda { Semverstringer::Semver.new :minor=>"a" }.should raise_error(ArgumentError)
		end

		it "should only allow integral version number components" do
			lambda { Semverstringer::Semver.new :minor=>1.2 }.should raise_error(ArgumentError)
		end
	end
end
