import sqlite3
from flask import Flask, render_template, request, redirect, url_for
import os
from datetime import datetime

app = Flask(__name__)

# Database setup
DATABASE = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'data', 'notes.db')
DATA_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'data')

def get_db_connection():
    conn = sqlite3.connect(DATABASE)
    conn.row_factory = sqlite3.Row # Allows accessing columns by name
    return conn

def init_db():
    if not os.path.exists(DATA_DIR):
        os.makedirs(DATA_DIR)
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS notes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            content TEXT NOT NULL,
            timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
        )
    ''')
    conn.commit()
    conn.close()

@app.route('/')
def index():
    conn = get_db_connection()
    notes_cursor = conn.execute('SELECT id, content, STRFTIME("%Y-%m-%d %H:%M:%S", timestamp) as timestamp FROM notes ORDER BY timestamp DESC')
    notes = notes_cursor.fetchall()
    conn.close()
    return render_template('index.html', notes=notes)

@app.route('/add', methods=['POST'])
def add_note():
    content = request.form['note_content']
    if content:
        conn = get_db_connection()
        conn.execute('INSERT INTO notes (content) VALUES (?)', (content,))
        conn.commit()
        conn.close()
    return redirect(url_for('index'))

@app.route('/delete/<int:note_id>', methods=['POST'])
def delete_note(note_id):
    conn = get_db_connection()
    conn.execute('DELETE FROM notes WHERE id = ?', (note_id,))
    conn.commit()
    conn.close()
    return redirect(url_for('index'))

if __name__ == '__main__':
    init_db() # Initialize DB and table if they don't exist
    app.run(host='0.0.0.0', port=5000, debug=True)
