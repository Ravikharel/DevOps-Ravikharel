from flask import Flask, jsonify, request
from flask_pymongo import PyMongo
from flask_cors import CORS

app = Flask(__name__)
CORS(app, resources={
    r"/todos*": {"origins": ["http://localhost", "http://127.0.0.1", "http://192.168.56.2"]}
})
# Configure MongoDB
app.config["MONGO_URI"] = "mongodb://mongodb:27017/todoapp"
mongo = PyMongo(app)
@app.route('/')
def home():
    return jsonify({"status": "backend is running"})

# Add error handler
@app.errorhandler(404)
def not_found(error):
    return jsonify({"error": "Not found"}), 404

@app.route('/todos', methods=['GET'])
def get_todos():
    todos = list(mongo.db.todos.find({}, {'_id': 0}))
    return jsonify(todos)

@app.route('/todos', methods=['POST'])
def add_todo():
    todo = request.json
    mongo.db.todos.insert_one(todo)
    return jsonify({"status": "success"}), 201

@app.route('/todos/<int:todo_id>', methods=['DELETE'])
def delete_todo(todo_id):
    mongo.db.todos.delete_one({"id": todo_id})
    return jsonify({"status": "success"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
