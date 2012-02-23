module Semverstringer
	class Semver
		def initialize(params={})
			if (params.has_key? :major) || (params.has_key? :minor) || (params.has_key? :patch)
				@major = get_valid_version_number(params, :major)
				@minor = get_valid_version_number(params, :minor)
				@patch = get_valid_version_number(params, :patch)
			else
				@major = @minor = 0
				@patch = 1
			end
		end

		def to_s
			"#{@major}.#{@minor}.#{@patch}"
		end

		#TODO: Extract this out as a mixin
		private
		def raise_if_invalid_version_number(hash, key)
			if hash.has_key? key
				raise ArgumentError.new("Positive integers only") if hash[key] < 0
				raise ArgumentError.new("Integral numbers only") if ! hash[key].integer? 
			end
		end

		private
		def get_valid_version_number(hash, key) 
			raise_if_invalid_version_number(hash, key)
			(hash.has_key? key) ? hash[key] : 0
		end

	end
end

