#!/usr/bin/python

import os
import sys
import signal
import json

FILE = "/tmp/audio.wav"
APP_KEY = "XEL1XZ9B6LIRBKVWP"
DURATION = 15

i = 10
last_verified = None
last_id = None
while last_verified == None and i > 0:
	i -= 1
	os.popen("rm %s" % FILE)
	os.popen("./timeout -s 15 -t %d ./record.sh 2>&1 >> /dev/null" % DURATION)
	os.popen("sleep 1 && killall -9 sox")
	
	# print 'sleep 5 && export ECHO_NEST_API_KEY=%s && ./lookup.py %s' % (APP_KEY, FILE)
	result = os.popen('sleep 5 && export ECHO_NEST_API_KEY=%s && ./lookup.py %s' % (APP_KEY, FILE)).read()
	data = json.loads(result)

	# print data
	if "song" in data:
		if last_id == data["song"]["id"] and last_verified != last_id:
			last_verified = last_id

			print result
			# print "New song playing: ", result
			os.popen('osascript -e \'display notification "%s" with title "%s"\'' % (data["song"]["title"].replace("'", " "), data["artist"]["name"].replace("'", " ")))
		last_id = data["song"]["id"]

if last_verified == None:
	print '{ "error": "No match found" }'
sys.exit(0)
