# app.py
# Import necessary modules from Flask
from flask import Flask, render_template, request, redirect, url_for
import datetime

# Create an instance of the Flask class
app = Flask(__name__)

# A simple in-memory list to store submissions.
# In a real application, you would use a database.
submissions = []

# Define a route for the homepage ('/').
@app.route('/')
def home():
    """Renders the homepage."""
    # We now use render_template to serve an HTML file.
    return render_template('index.html')

# Define a route for the submission form page.
# This route handles both GET (displaying the form) and POST (submitting data) requests.
@app.route('/submit', methods=['GET', 'POST'])
def submit():
    """Handles the form submission."""
    if request.method == 'POST':
        # Get data from the form
        name = request.form['name']
        message = request.form['message']
        timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")

        # Store the submission
        if name and message:
            submissions.append({'name': name, 'message': message, 'timestamp': timestamp})
            return redirect(url_for('thank_you'))

    # If it's a GET request, just show the form
    return render_template('form.html')

# Define a route to display all submissions.
@app.route('/submissions')
def show_submissions():
    """Displays all submitted messages."""
    return render_template('submissions.html', submissions=submissions)

# Define a simple "thank you" page to show after a successful submission.
@app.route('/thankyou')
def thank_you():
    """Renders the thank you page."""
    return render_template('thank_you.html')

# Main execution block
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
