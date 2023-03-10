import jwt from 'jsonwebtoken';

const auth = async (req, res, next) => {
    try {
        const token = req.header('x-auth-token');
        if (!token) return res.status(401).json({msg: 'No auth token, access denied'});

        const verified = jwt.verify(token, 'something');
        if (!verified) return res.status(401).json({msg: 'Unauthorized access'});

        req.user = verified.id;
        req.token = token;
        next();
    } catch (error) {
        res.status(500).json({error: e.message});
    }
}

export default auth;
