require 'spec_helper'

include Awsnap

describe Request do
  
  before(:each) do
    time = Time.utc(2012, 7, 15, 13, 27)
    Time.stub(:now).and_return(time)
  end
  
  describe "query string parameters" do
    subject {Request.new("url.example.foo", :get, params)}

    describe "normalizing the expires param" do
      context "when the expires param is a Ruby Time object" do
        let(:params) {{:expires => Time.utc(2012, 7, 15, 13, 27), :other => "Params"}}
        it "converts the date to ISO8601 representation" do
          subject.send(:expires_iso8601).should eql("2012-07-15T13:27:00Z")
        end
      end
      
      context "when the expires param is a String" do
        let(:params) {{:expires => "2012-07-15T13:27:00Z", :other => "Params"}}
        it "passes the date through" do
          subject.send(:expires_iso8601).should eql("2012-07-15T13:27:00Z")
        end
      end
      
      context "when the expires param is missing" do
        let(:params) {{:other => "Params"}}
        it "generates an expires param fifteen seconds from now" do
          subject.send(:expires_iso8601).should eql("2012-07-15T13:27:15Z")
        end
      end
    end

    context "when the params contain unreserved characters" do
      # These unreserved characters are A-Z, a-z, 0-9, hyphen ( - ), underscore ( _ ), period ( . ), and tilde ( ~ ).
      let(:params) {{"one-POW" => "two", "Three" => "four.omg~heloooo", "five" => "six~seven~eight"}}
      
      its(:canonicalized_params) {
        should eql [["Expires", "2012-07-15T13%3A27%3A15Z"], ["SignatureMethod", "HmacSHA256"], ["SignatureVersion", "2"], ["Three", "four.omg~heloooo"], ["five", "six~seven~eight"], ["one-POW", "two"]]
      }
      
      its(:params_string) {
        should eql "Expires=2012-07-15T13%3A27%3A15Z&SignatureMethod=HmacSHA256&SignatureVersion=2&Three=four.omg~heloooo&five=six~seven~eight&one-POW=two"
      }
    end
    
    context "when the params contain reserved characters" do
      let(:params) {{"POW!" => "Frazz!!*", "Bam!" => "Bibim bap (Korean pancake)", "Ammount" => "$21.67"}}
      
      its(:canonicalized_params) {
        should eql [["Ammount", "%2421.67"], ["Bam%21", "Bibim%20bap%20%28Korean%20pancake%29"], ["Expires", "2012-07-15T13%3A27%3A15Z"], ["POW%21", "Frazz%21%21%2A"], ["SignatureMethod", "HmacSHA256"], ["SignatureVersion", "2"]]
      }
      
      its(:params_string) {
        should eql "Ammount=%2421.67&Bam%21=Bibim%20bap%20%28Korean%20pancake%29&Expires=2012-07-15T13%3A27%3A15Z&POW%21=Frazz%21%21%2A&SignatureMethod=HmacSHA256&SignatureVersion=2"
      }
    end
  end
  
  describe "AWS credentials" do
    subject {Request.new("some.example.url", :get, params)}
    let(:params) {{:access_key_id => "1234567890", :secret_access_key => "123456789012", :some => "other", :params => "here"}}
    its(:access_key_id) {should eql("1234567890")}
    its(:secret_access_key) {should eql("123456789012")}
  end
  
  describe "implicit verb" do
    subject {Request.new("http://some.example.url", {:some => "params"})}
    its(:verb) {should be :get}
  end
  
  describe "signing" do
    subject {Request.new(url, verb, params)}
    let(:verb) {:get}
    let(:url)  {"https://sqs.us-east-1.amazonaws.com/770098461991/queue2"}
    let(:params) {{:access_key_id => "1234567890", :secret_access_key => "123456789012", "POW!" => "Frazz!!*", "Bam!" => "Bibim bap (Korean pancake)", "Ammount" => "$21.67"}}
    
    its(:string_to_sign) {should eql %Q{GET\nsqs.us-east-1.amazonaws.com\n/770098461991/queue2\nAWSAccessKeyId=1234567890&Ammount=%2421.67&Bam%21=Bibim%20bap%20%28Korean%20pancake%29&Expires=2012-07-15T13%3A27%3A15Z&POW%21=Frazz%21%21%2A&SignatureMethod=HmacSHA256&SignatureVersion=2}}
    its(:hmac_signature) {should eql %Q{\xFC\x8E%\xA7\x84[\xA8\xC6\xF4M\x91=\xEF\eZ$m\xB9MPu\xD7\x80\xE6\x97\xE5\x87\xE9\xB9\xD9\x95\xD3}}
    its(:signature)      {should eql %Q{%2FI4lp4RbqMb0TZE97xtaJG25TVB114Dml%2BWH6bnZldM%3D}}
  end
end