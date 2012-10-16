#!/usr/bin/env ruby



require 'cgi'
require 'json'
require 'net/http'

begin
  require 'URI'
rescue LoadError
end



module ServerThumb

  FACEBOOK_GRAPH_BASE_URL = 'https://graph.facebook.com/'

  def self.url_to_id(query_url)
    query_string = CGI.escape("select url, id, type, site from object_url where url = \"#{query_url}\"").gsub('+', '%20')
    url = FACEBOOK_GRAPH_BASE_URL + "fql?q=" + query_string
    puts url

    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == 'https'
    request = Net::HTTP::Get.new(uri.path)
    response = http.request(request)
    decoded_json = JSON.parse(response.body)
  end

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
