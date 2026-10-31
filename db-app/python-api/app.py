from flask import Flask, jsonify
import os
import getpass
import psycopg2


app = Flask(__name__)

# Fetches user information from environment variables
db_name = os.environ.get('POSTGRES_DB')
db_user = os.environ.get('POSTGRES_USER')
db_host = os.environ.get('DB_HOST')
db_port = os.environ.get('DB_PORT')
db_password = os.environ.get('POSTGRES_PASSWORD')

try:
    conn = psycopg2.connect(
        dbname=db_name,
        user=db_user,
        host="localhost",
        port=5432,
        password=db_password
    )
except:
    print("I am unable to connect to the database")

@app.route('/health')
def health_check():
    # Responds with status and user name
    return jsonify({
        "status": "healthy",
        "user": getpass.getuser()
    })

@app.route('/users')
def get_users():
    with conn.cursor() as curs:
        curs.execute("SELECT id, name FROM Users;")
        users = curs.fetchall()
        user_list = [{"id": user[0], "name": user[1]} for user in users]
    return jsonify(user_list)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
