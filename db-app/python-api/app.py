from flask import Flask, jsonify
import os
import getpass

app = Flask(__name__)

@app.route('/health')
def health_check():
    # Responds with status and user name
    return jsonify({
        "status": "healthy",
        "user": getpass.getuser()
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
