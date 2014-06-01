import api
import sys
import json

def compareStrings(s1, s2):
	if unidecode(s1.lower()) == unidecode(s2.lower()):
		return True
	return False

def search(artist, title):
	token = open('/tmp/auth.token', 'r').read()
	search = api.searchAPI(token, artist + ' ' + title)
	if "error" in search or int(search["total"]) == 0:
		return None
	data = search["data"]
	toAdd = None
	for entry in data:
		if entry["type"] != "track":
			continue
		if entry["artist"]["name"].lower().strip() == artist.lower().strip()	\
			and entry["title"].lower().strip() == title.lower().strip():
			toAdd = entry
			break
	if toAdd == None:
		return {"error":"No match found"}
	return toAdd


if __name__ == "__main__":
	if len(sys.argv) < 3:
		print {"error":"You must provide artist and title."}
		sys.exit()
	add = search(sys.argv[1], sys.argv[2])
	if add == None:
		print json.dumps({"error":True})
	else:
		print json.dumps(add)
