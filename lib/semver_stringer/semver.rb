module SemverStringer
	class Semver

    # Creates a new Semver instance.
    #
    # @param [Hash] params the options to create a message with.
    # @option params [Integer] :major Major version number 
    # @option params [Integer] :minor Minor version number
    # @option params [Integer] :patch Patch version number
    # @option params [String, Integer, Array<String, Integer>] :pre Pre-release identifier(s)
    # @option params [String, Integer, Array<String, Integer>] :build Build number identifier(s)
		def initialize(params={})
			@major, @minor, @patch = get_version_numbers_from params
			@build = get_build_string_from params
			@pre = get_pre_string_from params
		end

    # Returns a string representation of the SemVer
    #
    # @example
    #   SemverStringer::Semver.new(:major=>2, :pre=>"alpha").to_s  #=> "2.0.0-alpha"
    #
    # @return [String]
		def to_s
			version = "#{@major}.#{@minor}.#{@patch}"
			version << "-#{@pre}" unless @pre == nil
			version << "+#{@build}" unless @build == nil
			version
		end

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

		private
		def get_version_numbers_from(params)
			if (params.has_key? :major) || (params.has_key? :minor) || (params.has_key? :patch)
				major = get_valid_version_number(params, :major)
				minor = get_valid_version_number(params, :minor)
				patch = get_valid_version_number(params, :patch)
			else
				major = minor = 0
				patch = 1
			end

			[major, minor, patch]
		end

		private
		def get_pre_string_from(params) 
			return get_optional_string_from params, :pre
		end

		private
		def get_build_string_from(params) 
			return get_optional_string_from params, :build
		end

		private
		def get_optional_string_from(params, type)
			disallowed_chars = /[^0-9A-Za-z-]/

			if params.has_key? type
				identifiers = scalar_to_array params[type]
					
				identifiers.each do |param|
					raise ArgumentError.new("Characters in #{type} ID are not allowed") if disallowed_chars.match param.to_s
				end

				return identifiers.join "."
			else
				return nil
			end
		end
	
		private 
		def scalar_to_array(scalar)
			(scalar.is_a? Array) ? scalar : Array.new(1, scalar)
		end
	end
end

