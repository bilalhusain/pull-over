require.paths.unshift '/usr/local/lib/node_modules'

request = require 'request'
credentials = require './credentials' # {APP_ID: 'cafe', OAUTH_TOKEN: 'babe'}


interstateUrl = (name, id) ->
	version = 'v1'
	format = 'json'
	path = '404'
	switch name
		when "list" then path = '/listAll'
		when "roads" then path = "/roads/id/#{id}"
		else throw 'unknown name'
	"https://api.interstateapp.com/#{version}/roadmap#{path}.#{format}?oauth_token=#{credentials.OAUTH_TOKEN}"

request.get interstateUrl('list'), (err, response, body) ->
	# display the roadmaps
	for roadmap in JSON.parse(body).response[credentials.APP_ID]
		console.log "[ROADMAP] #{roadmap.title}"

		# display the information about roads
		request.get interstateUrl('roads', roadmap._id), (err, response, body) ->
			for road in JSON.parse(body).response
				console.log "[ROAD] #{road.title}"
				console.log "#{road.description}"

