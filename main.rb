#!/usr/bin/env ruby

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

# Get all routes
routesAll = []
Sinatra::Application.routes["GET"].each do |route|
	routesAll.push(route[0].to_s)
end

# Get all 1xx routes
get "/1xx" do
	content_type :json
	routes1xx = routesAll.select do |route|
		route[1] == "1"
	end
	{ routes: "#{routes1xx}" }.to_json
end

# Get all 2xx routes
get "/2xx" do
	content_type :json
	routes2xx = routesAll.select do |route|
		route[1] == "2"
	end
	{ routes: "#{routes2xx}" }.to_json
end

# Get all 3xx routes
get "/3xx" do
	content_type :json
	routes3xx = routesAll.select do |route|
		route[1] == "3"
	end
	{ routes: "#{routes3xx}" }.to_json
end

# Get all 4xx routes
get "/4xx" do
	content_type :json
	routes4xx = routesAll.select do |route|
		route[1] == "4"
	end
	{ routes: "#{routes4xx}" }.to_json
end

# Get all 5xx routes
get "/5xx" do
	content_type :json
	routes5xx = routesAll.select do |route|
		route[1] == "5"
	end
	{ routes: "#{routes5xx}" }.to_json
end

# Root route
get "/" do
	content_type :json
	{ info: "No route has been configured for /. For lists of 1xx, 2xx, 3xx, 4xx or 5xx routes, please refer to the following routes: /1xx, /2xx, /3xx, /4xx, /5xx" }.to_json
end
