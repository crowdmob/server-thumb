#!/usr/bin/env ruby



require 'cgi'
require 'json'
require 'net/http'
require 'open-uri'



module ServerThumb

  FACEBOOK_GRAPH_BASE_URL = 'https://graph.facebook.com/'

  def self.like(access_token, object_id)
    url = FACEBOOK_GRAPH_BASE_URL + object_id + '/og.likes'
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == 'https'
    request = Net::HTTP::Post.new(uri.path)
    data = { access_token: access_token, object: object_id }
    request.set_form_data(data)

    begin
      response = http.request(request)
    rescue OpenURI::HTTPError
      # The user has already liked the Facebook object.
    end
    decoded_json = JSON.parse(response.body)
  end

end
