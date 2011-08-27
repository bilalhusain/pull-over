require.paths.unshift '/usr/local/lib/node_modules'

request = require 'request'
credentals = require './credentials' # {APP_ID: 'cafe', OAUTH_TOKEN: 'babe'}


interstateUrl = (name, id) ->
	version = 'v1'
	format = 'json'
	path = '404'
	switch name
		when "list" then path = '/listAll'
		when "roads" then path = "/roads/id/#{id}"
		else throw 'unknown name'
	"https://api.interstateapp.com/#{version}/roadmap#{path}.#{format}?oauth_token=#{credentals.OAUTH_TOKEN}"

request.get interstateUrl('list'), (err, response, body) ->
	# display the roadmaps
	for roadmap in JSON.parse(body).response[credentals.APP_ID]
		console.log "Listing roads for #{roadmap.title}"

		# display the information about roads
		request.get interstateUrl('roads', roadmap._id), (err, response, body) ->
			for road in JSON.parse(body).response
				console.log "#{road.title}; #{road.description}"

