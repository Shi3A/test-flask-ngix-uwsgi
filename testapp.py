from flask import Flask
import sys, inspect, os

app = Flask(__name__)


@app.route('/')
def hello_world():
    ver = str(sys.version_info)
    insp = str(inspect.getfile(inspect.currentframe()))
    fpath = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
    page = ('Hello World! <br> {} <br> {} <br> {}'.format(ver, insp, fpath))
    return page

if __name__ == '__main__':
    app.run()
