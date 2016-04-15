from flask import Flask, make_response, render_template, request, send_from_directory
import os
import signal
import subprocess

app = Flask(__name__, template_folder='assets')
p = None


@app.route('/')
def index():
    global p
    if p is not None:
        os.killpg(os.getpgid(p.pid), signal.SIGTERM)

    p = subprocess.Popen(['clips', '-u'], stdout=subprocess.PIPE, stdin=subprocess.PIPE, shell=True, preexec_fn=os.setsid)
    send_to_clips('', skip=True)  # Hack to ignore initial clips printout.

    with open('load.clp', 'r') as f:
        for line in f:
            if len(line) > 1:  # If not empty line...
                send_to_clips(line)

    send_to_clips('(reset)')  # Reset.

    return render_template('index.html')


@app.route('/assets/<path:filename>')
def content(filename):
    return send_from_directory('assets', filename)


@app.route('/input', methods=['POST'])
def input():
    text = request.values['text']
    res = make_response(send_to_clips(text))
    return res


def send_to_clips(command, skip=False):
    if not skip:
        p.stdin.write(command + '\n')
        p.stdin.flush()

    buf = []
    res = ''

    while True:
        line = p.stdout.read(1)
        buf.append(line)
        if len(buf) > 6:
            buf = buf[1:7]
        if ''.join(buf) == 'CLIPS>':
            res = res[:-5]
            break
        if ''.join(buf) == '</end>':
            res = res[:-5]
            break
        res += line

    p.stdout.flush()
    return res


if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)
