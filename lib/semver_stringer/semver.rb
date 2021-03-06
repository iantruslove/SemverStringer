module SemverStringer

  class Semver
    include Comparable

    class Substring
      include Comparable

      def initialize(s) 
        @str = s
      end

      def <=>(other)
        other_str = other.instance_variable_get('@str')
        return Substring::compareVersionStrings @str, other_str
      end

      def self.compareVersionStrings(first, second)
        first_components = first.split('.')
        second_components = second.split('.')

        first_head = first_components.shift
        second_head = second_components.shift

        head_comparison = compare_version_atoms first_head, second_head
        if head_comparison == 0
          if first_components.length > 0 or second_components.length > 0 
            return Substring::compareVersionStrings first_components.join('.'), second_components.join('.')
          else
            return 0
          end
        else 
          return head_comparison
        end
      end

      def self.compare_version_atoms(first, second)
        if first == nil and second == nil
          return nil
        elsif first != nil and second == nil
          return 1
        elsif first == nil and second != nil
          return -1 
        else
          unless first.match /[^0-9]/ or second.match /[^0-9]/
            return first.to_i <=> second.to_i
          else
            return first <=> second
          end
        end
      end

    end

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


    # All the semver.org comparison rules are expressed by this operator
    def <=>(other) 

      versionComparison = Substring.new(get_version_string) <=> Substring.new(other.get_version_string)
      (return versionComparison) if versionComparison != 0

      other_pre = other.instance_variable_get('@pre')
      if @pre != nil and other_pre == nil
        return -1
      elsif @pre == nil and other_pre != nil
        return 1
      elsif @pre != nil and other_pre != nil
        pre_comparison = Substring.new(@pre) <=> Substring.new(other_pre)
        (return pre_comparison) if pre_comparison != 0
      end

      other_build = other.instance_variable_get('@build')
      if @build == nil and other_build != nil
        return -1
      elsif @build != nil and other_build == nil
        return 1
      elsif @build != nil and other_build != nil
        build_comparison = Substring.new(@build) <=> Substring.new(other_build)
        (return build_comparison) if build_comparison != 0
      end

      return 0
    end

    def get_version_string
      "#{@major}.#{@minor}.#{@patch}"
    end

    def get_pre_string
      @pre
    end

    def get_build_string
      @build
    end

    # Returns a string representation of the SemVer
    #
    # @example
    #   SemverStringer::Semver.new(:major=>2, :pre=>"alpha").to_s  #=> "2.0.0-alpha"
    #
    # @return [String]
    def to_s
      version = get_version_string
      version << "-#{get_pre_string}" unless @pre == nil
      version << "+#{get_build_string}" unless @build == nil
      version
    end

    private
    def raise_if_invalid_version_number(hash, key)
      if hash.has_key? key
        raise ArgumentError.new("Positive integers only") if hash[key] < 0
        raise ArgumentError.new("Integral numbers only") if ! hash[key].integer? 
      end
    end

    def get_valid_version_number(hash, key) 
      raise_if_invalid_version_number(hash, key)
      (hash.has_key? key) ? hash[key] : 0
    end

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

    def get_pre_string_from(params) 
      return get_optional_string_from params, :pre
    end

    def get_build_string_from(params) 
      return get_optional_string_from params, :build
    end

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

    def scalar_to_array(scalar)
      (scalar.is_a? Array) ? scalar : Array.new(1, scalar)
    end
  end
end
