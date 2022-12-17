import express from 'express';
import mongoose from 'mongoose';
import authRouter from './routes/auth.js';

const PORT= 3000;

const app = express();
const db = "mongodb+srv://amazon:password12345@cluster0.zufjuq2.mongodb.net/?retryWrites=true&w=majority";

// MIDDLEWARES
app.use(express.json());
app.use(authRouter);

//CONNECTION
mongoose.set('strictQuery', true);
mongoose.connect(db).then(() => {
    console.log('Successful');
}).catch(e => console.log(e));

// API
app.listen(PORT, '0.0.0.0', () => {
    console.log('connected to ', PORT);
});
