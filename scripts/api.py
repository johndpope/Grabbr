import requests

def requestAPI(token, model, id, action="", params={}, method='GET'):
	if action != 'GET':
		params["request_method"] = action
	params["output"] = "json"
	params['access_token'] = token
	url = "http://api.deezer.com/" + model + '/' + str(id) + '/' + action
	r = requests.get(url, params=params)
	return r.json()

def searchAPI(token, query):
	params = {'output':'json', 'access_token': token}
	url = "http://api.deezer.com/search?q=" + query
	r = requests.get(url, params=params)
	print r.url
	return r.json()

def addTrackToPlaylist(token, playlist, track):
	params = {'output':'json', 'access_token': token, 'songs':str(track), 'request_method':'POST'}
	url = "http://api.deezer.com/playlist/"+str(playlist)+"/tracks"
	r = requests.get(url, params=params)
	return r.json()
