from flask import Flask, render_template, request, redirect
import mysql.connector

app = Flask(__name__)

def get_db_connection():
    return mysql.connector.connect(
        host='db',
        user='user',
        password='userpass',
        database='demo'
    )

@app.route('/', methods=['GET', 'POST'])
def index():
    conn = get_db_connection()
    cursor = conn.cursor()

    if request.method == 'POST':
        name = request.form['name']
        vote = request.form['vote']
        cursor.execute("INSERT INTO votes (name, vote) VALUES (%s, %s)", (name, vote))
        conn.commit()

    cursor.execute("SELECT * FROM votes")
    results = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('index.html', results=results)

