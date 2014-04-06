import api
import sys
import json

def getUserPlaylists():
	token = open('/tmp/auth.token', 'r').read()
	playlists = api.requestAPI(token, 'user', 'me', 'playlists')
	if 'data' in playlists:
		return playlists["data"]
	return None

def compareStrings(s1, s2):
	if unidecode(s1.lower()) == unidecode(s2.lower()):
		return True
	return False

def addTrackToPlaylist(playlist, artist, title):
	token = open('/tmp/auth.token', 'r').read()
	search = api.searchAPI(token, artist + ' ' + title)
	if "error" in search or int(search["total"]) == 0:
		return None
	data = search["data"]
	toAdd = None
	for entry in data:
		if entry["type"] != "track":
			continue
		if entry["artist"]["name"].lower() == artist.lower()	\
		   and entry["title"].lower() == title.lower():
		   toAdd = entry
		   break
	if toAdd == None:
		return {"error":"No match found"}
	return api.addTrackToPlaylist(token, playlist, toAdd["id"])


if __name__ == "__main__":
	if len(sys.argv) < 2:
		print {"error":"You must provide arguments."}
		sys.exit()
	if sys.argv[1] == "get":
		playlists = getUserPlaylists()
		if playlists == None:
			print json.dumps({"error":True})
		else:
			print json.dumps(playlists)
	elif sys.argv[1] == "add":
		if len(sys.argv) < 5:
			print {"error":"You must provide playlist, artist and album."}
			sys.exit()
		add = addTrackToPlaylist(sys.argv[2], sys.argv[3], sys.argv[4])
		if add == None:
			print json.dumps({"error":True})
		else:
			print json.dumps(add)
