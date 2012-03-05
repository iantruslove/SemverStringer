# SemverStringer #

Gives you a little help with your [semver](http://semver.org/) strings. 

## Usage

		require 'semver_stringer'
		
		semver = SemverStringer::Semver.new
		semver.to_s 	# => "0.0.1"

		version_info = { 
			:major=>2,  # integer, >= 0
			:minor=>1,  # integer, >= 0
			:patch=>13, # integer, >= 0
			:pre=>["alpha", 1],  # string ([A-Za-z0-9-]*), integer >=0, or list of these
			:build=>2134         # string ([A-Za-z0-9-]*), integer >=0, or list of these	
		}
		semver = SemverStringer::Semver.new version_info
		semver.to_s 	# => "2.1.13-alpha.1+2134"

### SemVer comparisons

`Semver` implements the comparable module, so it's easy to compare 
one Semver with another. The rules for comparisons are taken from
the spec at semver.org.  Example:

    version1 = SemverStringer::Semver.new :major=>1, :minor=>0, :patch=>0
    version2alpha = SemverStringer::Semver.new :major=>2, :minor=0, :patch=>0, :pre=>"alpha"
    version2 = SemverStringer::Semver.new :major=>2, :minor=0, :patch=>0

    version1 < version2alpha  #=> true
    version2alpha < version2  #=> true

## TODO

* Constructor taking string parameter for parsing and initialization
