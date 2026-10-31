from flask import Flask, jsonify
import os
import psycopg2


app = Flask(__name__)

# Fetches user information from environment variables
db_name = os.environ['DB_NAME']
db_user = os.environ['DB_USER']
db_host = os.environ['DB_HOST']
db_port = os.environ['DB_PORT']
db_password = os.environ['DB_PASSWORD']

@app.route('/health')
def health_check():
    conn = None
    try:
        conn = psycopg2.connect(
            dbname=db_name,
            user=db_user,
            host=db_host,
            port=db_port,
            password=db_password
        )
        with conn.cursor() as curs:

            # Checks if the database connection is alive
            curs.execute("SELECT 1")
            # Responds with status and database connection status
            return jsonify({
                "status": "healthy",
                "db": "ok"
            })
    except psycopg2.Error:
        # Handles database connection errors and responds with an error message
        return jsonify({
            "status": "unhealthy",
            "db": "down"
        }), 503
    finally:
        if conn is not None:
            conn.close()

@app.route('/users')
def get_users():
    conn = None
    try:
        conn = psycopg2.connect(
            dbname=db_name,
            user=db_user,
            host=db_host,
            port=db_port,
            password=db_password
        )
        with conn.cursor() as curs:
            curs.execute("SELECT id, name FROM users;")
            users = curs.fetchall()
            user_list = [{"id": user[0], "name": user[1]} for user in users]
        return jsonify(user_list)
    except psycopg2.Error as e:
        # Handles database connection errors and responds with an error message
        app.logger.exception("users query failed")
        return jsonify({"error": "Failed to fetch users"}), 503
    finally:
        if conn is not None:
            conn.close()

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

