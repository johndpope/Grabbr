#!/usr/bin/python

import os
import signal
import json

TIMEOUT = 20

def handler(signum, frame):
    print 'Signal handler called with signal', signum
    raise IOError("Couldn't open device!")

signal.signal(2, handler)
signal.signal(6, handler)
signal.signal(15, handler)

last_verified = None
last_id = None
while True:
	os.popen("scripts/timeout -s 15 -t %d scripts/record.sh 2>&1 >> /dev/null" % TIMEOUT)
	os.popen("sleep 1 && killall -9 sox")
	
	result = os.popen('export ECHO_NEST_API_KEY=XEL1XZ9B6LIRBKVWP && scripts/lookup.py /tmp/audio.wav').read()
	data = json.loads(result)

	print data
	if "song" in data:
		if last_id == data["song"]["id"] and last_verified != last_id:
			last_verified = last_id

			print "New song playing: ", result
			os.popen('osascript -e \'display notification "%s" with title "%s"\'' % (data["song"]["title"].replace("'", " "), data["artist"]["name"].replace("'", " ")))
		last_id = data["song"]["id"]
