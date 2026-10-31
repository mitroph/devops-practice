from flask import Flask, jsonify
import os
import getpass
import psycopg2


app = Flask(__name__)

# Fetches user information from environment variables
db_name = os.environ['POSTGRES_DB']
db_user = os.environ['POSTGRES_USER']
db_host = os.environ['DB_HOST']
db_port = os.environ['DB_PORT']
db_password = os.environ['POSTGRES_PASSWORD']

conn = psycopg2.connect(
            dbname=db_name,
            user=db_user,
            host=db_host,
            port=db_port,
            password=db_password
        )

@app.route('/health')
def health_check():
    try:
        # Checks if the database connection is alive
        conn.cursor().execute("SELECT 1")
        # Responds with status and database connection status
        return jsonify({
            "status": "healthy",
            "db": "ok"
        })
    except:
        # Handles database connection errors and responds with an error message
        return jsonify({
            "db": "down"
        }), 503

@app.route('/users')
def get_users():
    with conn.cursor() as curs:
        curs.execute("SELECT id, name FROM Users;")
        users = curs.fetchall()
        user_list = [{"id": user[0], "name": user[1]} for user in users]
    return jsonify(user_list)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
