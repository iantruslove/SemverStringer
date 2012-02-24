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

## TODO

* Comparison operators to implement the ordering as laid out in the semver spec.
