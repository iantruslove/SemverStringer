require 'semver_stringer/semver'

describe SemverStringer::Semver do
	describe "parameterless construction" do
		it "can be initialized with no parameters" do 
			semver = SemverStringer::Semver.new 
		end

		it "will output a default version string of 0.0.1" do
			semver = SemverStringer::Semver.new 
			semver.to_s.should == "0.0.1"
		end
	end

	describe "parameterized construction" do
		it "can be constructed with integer parameter for major version" do
			semver = SemverStringer::Semver.new :major => 1
			semver.to_s.should == "1.0.0"
		end

		it "can be constructed with integer parameter for minor version" do
			semver = SemverStringer::Semver.new :minor => 2
			semver.to_s.should == "0.2.0"
		end

		it "can be constructed with integer parameter for patch version" do
			semver = SemverStringer::Semver.new :patch => 23
			semver.to_s.should == "0.0.23"
		end

		it "can be constructed with combinations of major, minor and patch versions" do
			semver = SemverStringer::Semver.new :major=>2, :minor=>4, :patch=>20
			semver.to_s.should == "2.4.20"
		end
	end

	describe "invalid initialization values" do
		it "should only allow positive version number components" do
			lambda { SemverStringer::Semver.new :minor=>-1 }.should raise_error(ArgumentError)
		end

		it "should only allow numeric version number components" do
			lambda { SemverStringer::Semver.new :minor=>"a" }.should raise_error(ArgumentError)
		end

		it "should only allow integral version number components" do
			lambda { SemverStringer::Semver.new :minor=>1.2 }.should raise_error(ArgumentError)
		end
	end

	describe "optional pre-release identifier" do
		it "can take an integer pre-release identifier" do
			semver = SemverStringer::Semver.new :pre=>1
			semver.to_s.should == "0.0.1-1"
		end

		it "can take alphanumeric pre-release id" do
			semver = SemverStringer::Semver.new :major=>2, :pre=>"alpha"
			semver.to_s.should == "2.0.0-alpha"
		end

		it "can accept a list of pre-release identifiers" do
			semver = SemverStringer::Semver.new :minor=>1, :pre=>["rc", 2, 20100401113022]
			semver.to_s.should == "0.1.0-rc.2.20100401113022"
		end

		it "will not allow disallowed characters for the pre-relase id" do
			lambda { SemverStringer::Semver.new :pre=>"period.is.forbidden" }.should raise_error(ArgumentError)
			lambda { SemverStringer::Semver.new :pre=>"underscore_is_forbidden" }.should raise_error(ArgumentError)
			lambda { SemverStringer::Semver.new :pre=>"special$chars@not*allowed!" }.should raise_error(ArgumentError)
			lambda { SemverStringer::Semver.new :pre=>["or", "in", "arrays!!!"] }.should raise_error(ArgumentError)
		end
	end

	describe "optional build identifier" do
		it "can take an integer build id" do
			semver = SemverStringer::Semver.new :major=>2, :build=>1234
			semver.to_s.should == "2.0.0+1234"
		end

		it "can take alphanumeric build id" do
			semver = SemverStringer::Semver.new :build=>"AaBb-123"
			semver.to_s.should == "0.0.1+AaBb-123"
		end

		it "can accept a list of build identifiers" do
			semver = SemverStringer::Semver.new :patch=>3, :build=>["build", 1, "aA", "2"]
			semver.to_s.should == "0.0.3+build.1.aA.2"
		end

		it "will not allow disallowed characters" do
			lambda { SemverStringer::Semver.new :build=>"period.is.forbidden" }.should raise_error(ArgumentError)
			lambda { SemverStringer::Semver.new :build=>"underscore_is_forbidden" }.should raise_error(ArgumentError)
			lambda { SemverStringer::Semver.new :build=>"special$chars@not*allowed!" }.should raise_error(ArgumentError)
			lambda { SemverStringer::Semver.new :build=>["or", "in", "arrays!!!"] }.should raise_error(ArgumentError)
		end
	end

	describe "the full semver kitchen sink" do
		it "supports any combination of major, minor, patch, pre-release and build identifiers" do
			options = { :major=>1, :minor=>2, :patch=>303, :pre=>"beta", :build=>["build",1234] }
			semver = SemverStringer::Semver.new options
			semver.to_s.should == "1.2.303-beta+build.1234"
		end
	end

  describe "semver comparson operator" do
    it "is equal if version numbers are all identical" do
      semver1 = SemverStringer::Semver.new :major=>2, :minor=>5, :patch=>9
      semver2 = SemverStringer::Semver.new :major=>2, :minor=>5, :patch=>9

      (semver1 <=> semver2).should == 0
      (semver1 < semver2).should == false
      (semver1 == semver2).should == true
      (semver1 > semver2).should == false

      (semver2 <=> semver1).should == 0
      (semver2 < semver1).should == false
      (semver2 == semver1).should == true
      (semver2 > semver1).should == false
    end    

    def assertFormerHigherThanLatter(higher, lower) 
      (higher <=> lower).should == 1
      (higher < lower).should == false
      (higher == lower).should == false
      (higher > lower).should == true

      (lower <=> higher).should == -1
      (lower < higher).should == true
      (lower == higher).should == false
      (lower > higher).should == false
    end
    
    it "gives highest precedence to major" do
      higher = SemverStringer::Semver.new :major=>3, :minor=>1, :patch=>1
      lower = SemverStringer::Semver.new :major=>2, :minor=>50, :patch=>50

      assertFormerHigherThanLatter higher, lower
    end

    it "gives second precedence to minor" do
      higher = SemverStringer::Semver.new :major=>2, :minor=>6, :patch=>1
      lower = SemverStringer::Semver.new :major=>2, :minor=>2, :patch=>900

      assertFormerHigherThanLatter higher, lower
    end

    it "considers pre-release semvers lower than non-pre-release semvers" do
      higher = SemverStringer::Semver.new
      lower = SemverStringer::Semver.new :pre=>1

      assertFormerHigherThanLatter higher, lower
    end

    it "compares pre numbers as integers" do
      higher = SemverStringer::Semver.new :pre=>11
      lower = SemverStringer::Semver.new :pre=>"2"

      assertFormerHigherThanLatter higher, lower
    end

    it "compares pre numbers with chars or - as strings" do
      higher = SemverStringer::Semver.new :pre=>"a"
      lower = SemverStringer::Semver.new :pre=>1

      assertFormerHigherThanLatter higher, lower
    end

    it "considers build-numbered semvers higher than non-build numbered semvers" do
      higher = SemverStringer::Semver.new :build=>1
      lower = SemverStringer::Semver.new 

      assertFormerHigherThanLatter higher, lower
    end

    it "ignores build numbers if the main versions are different" do
      higher = SemverStringer::Semver.new :major=>2, :minor=>6, :patch=>1
      lower = SemverStringer::Semver.new :major=>2, :minor=>5, :patch=>1, :build=>9

      assertFormerHigherThanLatter higher, lower
    end

    it "compares integer build numbers as integers" do
      higher = SemverStringer::Semver.new :build=>11
      lower = SemverStringer::Semver.new :build=>"2"

      assertFormerHigherThanLatter higher, lower
    end

    it "compares build numbers with chars or - as strings" do
      higher = SemverStringer::Semver.new :build=>"a"
      lower = SemverStringer::Semver.new :build=>1

      assertFormerHigherThanLatter higher, lower
    end

    
  end

end
