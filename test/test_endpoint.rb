# encoding: utf-8
#
# Copyright (c) 2017 Yegor Bugayenko
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the 'Software'), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

require 'test/unit'
require 'rack/test'
require_relative '../objects/base'
require_relative '../objects/endpoint'
require_relative '../objects/endpoints'
require_relative '../objects/dynamo'

class EndpointTest < Test::Unit::TestCase
  def test_pings_valid_uri
    dynamo = Dynamo.new.aws
    id = Endpoints.new(dynamo, 'yegor256').add(
      'http://www.yegor256.com'
    )
    ep = Base.new(dynamo).take(id)
    assert(ep.ping.end_with?('200'))
  end

  def test_pings_broken_uri
    dynamo = Dynamo.new.aws
    id = Endpoints.new(dynamo, 'yegor256').add(
      'http://www.sixnines-broken-uri.io'
    )
    ep = Base.new(dynamo).take(id)
    ep.ping
    assert(ep.ping.end_with?('500'))
  end
end
