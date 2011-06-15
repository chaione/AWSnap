AWSnap!
=======
Ever felt like AWS libraries do to much? Like they wrap your workflow in lots of request processing, response handling and other gunk? AWSnap cuts to the chase: just give it an AWS API endpoint and some params, and it'll spit out a signed URI. You take it from there.

Ever felt like AWS libraries don't do enough? They make it easy to do S3, Cloudfront, maybe some SQS. But if you wander off the path, you're on your own. AWSnap has your back: integrate any AWS API on your own, and sign requests with AWSnap.

Examples
--------
    request = Awsnap::Request.new("https://sqs.us-east-1.amazonaws.com/", 
                :get, 
                {"Action" => "ListQueues", 
                 "Version" => "2009-02-01", 
                 :access_key_id => <Your-Access-Key-ID>, 
                 :secret_access_key => <Your-Secret-Access-Key>, 
                 :expires => 10.minutes.from_now}
                )

    request.to_s 
    #=> "https://sqs.us-east-1.amazonaws.com/?AWSAccessKeyId=Your-Access-Key-ID&Action=ListQueues&Expires=2011-06-15T10%3A21%3A27-07%3A00&SignatureMethod=HmacSHA256&SignatureVersion=2&Version=2009-02-01&Signature=CrazySignatureMadnessHere"

Alternatives
------------
If you're looking for a library that does a little more, these are great:

* [aws-s3](https://github.com/marcel/aws-s3)
* [RightAWS](https://github.com/rightscale/right_aws)  
* [Happening](https://github.com/peritor/happening)
* [Fog](https://github.com/geemus/fog)

Copyright
---------
(The MIT License)

Copyright © 2011 (Scott Burton)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.