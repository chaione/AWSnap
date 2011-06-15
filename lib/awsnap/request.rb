module Awsnap
  class Request
    
    attr_reader :verb, :params, :access_key_id, :secret_access_key
    
    def initialize(url, verb = :get, params)
      @verb   = verb
      @url = URI.parse(url)
      @access_key_id = params.delete(:access_key_id)
      @secret_access_key = params.delete(:secret_access_key)
      @expires = params.delete(:expires) || params.delete("Expires")
      @params = params.stringify_keys
    end
    
    def canonicalized_params
      normalized_params.sort.inject([]) {|params, pair| params.push(pair.map {|i| URI.encode(i, reserved_characters)}); params}
    end
    
    def params_string
      canonicalized_params.map{|pair| "#{pair[0]}=#{pair[1]}" }.join("&")
    end
    
    def string_to_sign
      "#{verb.to_s.upcase}\n#{@url.host}\n#{@url.path}\n#{params_with_access_key}"
    end
    
    def hmac_signature
      HMAC::SHA256.digest(secret_access_key, string_to_sign)
    end
    
    def signature
      URI.encode(Base64.encode64(hmac_signature).strip, reserved_characters)
    end
    
    def to_s
      "https://#{@url.host}#{@url.path}?#{params_with_access_key}&Signature=#{signature}"
    end
    
    private
    
    def normalized_params
      params.merge!({"Expires" => expires_iso8601, "SignatureVersion" => "2", "SignatureMethod" => "HmacSHA256"})
    end
    
    def expires_iso8601
      return @expires.iso8601 if @expires.respond_to?(:iso8601)
      return @expires if @expires
      (Time.now + 15.seconds).iso8601
    end
    
    def reserved_characters
      %r|[^\w\d\-_\.~]+|
    end
    
    def params_with_access_key
      "AWSAccessKeyId=#{access_key_id}&#{params_string}"
    end
    
  end
end