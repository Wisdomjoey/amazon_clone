import express from 'express';
import bcryptjs from 'bcryptjs';
import jwt from 'jsonwebtoken';
import User from '../models/userModel.js';
import auth from '../middlewares/auth.js';

const authRouter = express.Router();

authRouter.post('/api/signup', async (req, res) => {
    try {
        const {name, email, password} = req.body;

    const userExist = await User.findOne({email});

    if (userExist) {
        return res.status(400).json({msg: 'User with same email exist!'});
    }

    const hashedPassword = await bcryptjs.hash(password, 8);

    let user = new User({
        name,
        email,
        password: hashedPassword
    });
    user = await user.save();
    res.json(user);
    } catch (e) {
        res.status(500).json({error: e.message});
    }
});

authRouter.post('/api/signin', async (req, res) => {
    try {
        const {name, email, password} = req.body;

    const userExist = await User.findOne({email});
		if (!userExist) {
        return res.status(400).json({msg: 'User already exist!'});
		}

		const isMatch = await bcryptjs.compare(password, userExist.password);
		if (!isMatch) {
        return res.status(400).json({msg: 'Wrong password!'});
		}

		const token = jwt.sign({id: userExist._id}, 'something');
		res.json({token, ...userExist._doc});
    } catch (e) {
        res.status(500).json({error: e.message});
    }
});

authRouter.post('/tokenIsValid', async (req, res) => {
    try {
			const token = res.header('x-auth-token');
			if (!token) return res.json(false);
			
			const verified = jwt.verify(token, 'something');
			if (!verified) return res.json(false);

			const user = await User.findById(verified.id);
			if (!user) return res.json(false);

			res.json(true);
    } catch (e) {
        res.status(500).json({error: e.message});
    }
});

authRouter.get('/', auth, async (req, res) => {
	const user = await User.findById(req.user);
	res.json({...user._doc, token: req.token});
});

export default authRouter;
