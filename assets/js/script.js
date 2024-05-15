window.onload = function() {
    const clientId = '700817734047-n45knu1hpn7028s50ndfjl743l01d72r.apps.googleusercontent.com';

    const handleCredentialResponse = (response) => {
        console.log('Encoded JWT ID token: ' + response.credential);
        fetch('/verify-token', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ token: response.credential })
        })
        .then(response => response.text())
        .then(data => console.log(data))
        .catch(error => console.error('Error:', error));
    };

    google.accounts.id.initialize({
        client_id: clientId,
        callback: handleCredentialResponse
    });

    google.accounts.id.renderButton(
        document.getElementById('googleSignIn'),
        { theme: 'outline', size: 'large' }
    );

    google.accounts.id.prompt();
};
