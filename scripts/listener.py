#!/usr/bin/python

import os
import signal
import json

def handler(signum, frame):
    print 'Signal handler called with signal', signum
    raise IOError("Couldn't open device!")

signal.signal(2, handler)
signal.signal(6, handler)
signal.signal(15, handler)

i = 10
last_verified = None
last_id = None
while i > 0:
	os.popen("./timeout -s 15 -t 10 ./record.sh 2>&1 >> /dev/null")
	os.popen("killall -9 sox")
	
	result = os.popen('export ECHO_NEST_API_KEY=XEL1XZ9B6LIRBKVWP && ./lookup.py /tmp/audio.wav').read()
	data = json.loads(result)

	print data
	if "song" in data:
		if last_id == data["song"]["id"] and last_verified != last_id:
			last_verified = last_id

			print "New song playing: ", result
			os.popen('osascript -e \'display notification "%s" with title "%s"\'' % (data["song"]["title"], data["artist"]["name"]))
		last_id = data["song"]["id"]
