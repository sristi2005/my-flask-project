// static/js/script.js

// Wait for the DOM to be fully loaded before running the script
document.addEventListener('DOMContentLoaded', function() {

    console.log("DOM fully loaded and parsed. Script is running.");

    // Add a simple confirmation alert when the form is submitted
    const submissionForm = document.querySelector('form');
    if (submissionForm) {
        submissionForm.addEventListener('submit', function() {
            // This is just a visual cue; the actual submission is handled by the server.
            // In a real SPA, you might prevent default and use fetch() here.
            alert('Your message is being submitted!');
        });
    }

    // Apply staggered animation to submission cards
    const submissions = document.querySelectorAll('.submission');
    if (submissions.length > 0) {
        submissions.forEach((card, index) => {
            // Apply a delay to each card based on its position in the list
            card.style.animationDelay = `${index * 0.1}s`;
        });
    }
});
