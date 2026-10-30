from flask import Flask, jsonify
import os
import getpass


app = Flask(__name__)

# Fetches user information from environment variables
db_host = os.environ.get('DB_HOST')
db_port = os.environ.get('DB_PORT')
db_name = os.environ.get('POSTGRES_DB')
db_user = os.environ.get('POSTGRES_USER')
db_password = os.environ.get('POSTGRES_PASSWORD')

@app.route('/health')
def health_check():
    # Responds with status and user name
    return jsonify({
        "status": "healthy",
        "user": getpass.getuser()
    })

@app.route('/users')
def get_users():
    # Returns the user information as JSON
    return jsonify({
        "db_host": db_host,
        "db_port": db_port,
        "db_name": db_name,
        "db_user": db_user,
        "db_password": db_password
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
