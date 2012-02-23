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

			if params.has_key? :build
				build_params = (params[:build].is_a? Array) ? params[:build] : Array.new(1, params[:build])
					
				build_params.each do |param|
					raise ArgumentError.new("Characters in build ID are not allowed") if /[^0-9A-Za-z-]/.match param.to_s
				end

				@build = build_params.join "."
			end
		end

		def to_s
			version = "#{@major}.#{@minor}.#{@patch}"
			version << "+build.#{@build}" unless @build == nil
			version
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

