const express = require('express');
const bodyParser = require('body-parser');
const verify = require('./verifyToken');

const app = express();
app.use(bodyParser.json());

app.post('/verify-token', async (req, res) => {
    const token = req.body.token;
    try {
        await verify(token);
        res.status(200).send('Token is valid');
    } catch (error) {
        res.status(400).send('Invalid token');
    }
});

const PORT = process.env.PORT || 8000;
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
