#!venv/bin/python
from flask import Flask, render_template, flash, request, send_from_directory, Markup
from urlparse import parse_qs
import requests

app = Flask(__name__)

@app.route('/')
@app.route('/index')
def index():
    debug = None
    # if api != None:
    #     seed = seedCatalog()
    #     seed.create('me', 1000)

    return render_template('index.html',
        content1 = Markup('<a href="https://connect.deezer.com/oauth/auth.php?app_id=135211&redirect_uri=http%3A%2F%2Flocalhost%3A5000%2Fauth%2F&perms=basic_access,manage_library">Login with Deezer!</a>'),
        content2 = 'thankubro')

@app.route('/auth/')
def auth():
    user = None
    api = None

    if "code" in request.args:
        
        app_id = "135211"
        app_secret = "c0da74a61122255c11b23b3c56028e2e"

        token_url = "https://connect.deezer.com/oauth/access_token.php?app_id=" + str(app_id) \
                    + "&secret=" + app_secret + "&code=" + request.args["code"]

        r = requests.get(token_url)
        if r.text == "wrong code":
            # throw error
            print "Error in auth http request"
        else:   
            r = r.text.replace("\n", "")
            r = parse_qs(r)
            auth_token = r["access_token"][0]
            auth_expire = int(r["expires"][0])
            file = open("/tmp/auth.token", "w")
            file.write(auth_token)

    elif 'error_reason' in request.args:
        return render_template('index.html',
            content1 = 'Authentification failed',
            content2 = Markup('<a href="https://connect.deezer.com/oauth/auth.php?app_id=135211&redirect_uri=http%3A%2F%2Flocalhost%3A5000%2Fauth%2F&perms=basic_access,manage_library">Try again</a>'))

    return render_template('index.html',
        content1 = 'You are now logged in !',
        content2 = 'enjoy using your app now')

@app.route('/assets/<path:filename>')
def static_files(filename):
    return send_from_directory('templates/assets/', filename)

app.run(debug = True, host='0.0.0.0')