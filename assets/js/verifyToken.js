const { OAuth2Client } = require('google-auth-library');
const client = new OAuth2Client('700817734047-n45knu1hpn7028s50ndfjl743l01d72r.apps.googleusercontent.com');

async function verify(token) {
    const ticket = await client.verifyIdToken({
        idToken: token,
        audience: '700817734047-n45knu1hpn7028s50ndfjl743l01d72r.apps.googleusercontent.com',
    });
    const payload = ticket.getPayload();
    console.log(payload);
    const userid = payload['sub'];
}

module.exports = verify;
