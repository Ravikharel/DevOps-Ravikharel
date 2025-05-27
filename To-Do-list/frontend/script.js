document.addEventListener('DOMContentLoaded', () => {
    fetchTodos();
});

async function fetchTodos() {
    try {
        const response = await fetch('http://192.168.56.2:5000/todos');
        const todos = await response.json();
        renderTodos(todos);
    } catch (error) {
        console.error('Error fetching todos:', error);
    }
}

async function addTodo() {
    const input = document.getElementById('todoInput');
    const text = input.value.trim();
    
    if (text) {
        try {
            const newTodo = {
                id: Date.now(),
                text: text,
                completed: false
            };
            
            await fetch('http://192.168.56.2:5000/todos', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(newTodo)
            });
            
            input.value = '';
            fetchTodos();
        } catch (error) {
            console.error('Error adding todo:', error);
        }
    }
}

async function deleteTodo(id) {
    try {
        await fetch(`http://192.168.56.2:5000/todos/${id}`, {
            method: 'DELETE'
        });
        fetchTodos();
    } catch (error) {
        console.error('Error deleting todo:', error);
    }
}

function renderTodos(todos) {
    const todoList = document.getElementById('todoList');
    todoList.innerHTML = '';
    
    todos.forEach(todo => {
        const li = document.createElement('li');
        li.innerHTML = `
            <span>${todo.text}</span>
            <button class="delete-btn" onclick="deleteTodo(${todo.id})">Delete</button>
        `;
        todoList.appendChild(li);
    });
}
