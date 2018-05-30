#!/usr/bin/env ruby

require "bundler/setup"
require "json"
require "sinatra"

routes1xx = File.read("routes/1xx/routes.json")
routes2xx = File.read("routes/2xx/routes.json")
routes3xx = File.read("routes/3xx/routes.json")
routes4xx = File.read("routes/4xx/routes.json")
routes5xx = File.read("routes/5xx/routes.json")

routes1xxJSON = JSON.parse(routes1xx)
routes2xxJSON = JSON.parse(routes2xx)
routes3xxJSON = JSON.parse(routes3xx)
routes4xxJSON = JSON.parse(routes4xx)
routes5xxJSON = JSON.parse(routes5xx)

routes = JSON.dump(routes1xxJSON.merge(routes2xxJSON).merge(routes3xxJSON).merge(routes4xxJSON).merge(routes5xxJSON))
statusCodes = JSON.parse(routes)

statusCodes.each {
	|statusCode, properties|
	get "/#{statusCode}" do
		content_type :json
		{ name: "#{properties['name']}", description: "#{properties['description']}" }.to_json
	end
}

# 404 route if an invalid route is specified
not_found do
	status 404
	content_type :json
	{ error: "An invalid route was specified" }.to_json
end
