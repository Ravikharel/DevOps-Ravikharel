# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container at /app
COPY requirements.txt .

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code into the container at /app
COPY . .

# Make port 5000 available to the world outside this container
EXPOSE 5000

# Ensure the data directory exists and has correct permissions if needed
# For SQLite, the app itself will create the db file in a mounted volume,
# so explicit directory creation here is less critical if volumes are used correctly.
# RUN mkdir -p /app/data && chown -R <user>:<group> /app/data # If you run as non-root

# Define environment variable (optional, for consistency)
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_ENV=production

# Run app.py when the container launches
# Using gunicorn for production is better, but for simplicity, we'll use Flask's dev server
CMD ["python", "app.py"]
# For a more production-ready setup, you'd use Gunicorn:
# CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
# And add 'gunicorn' to requirements.txt
