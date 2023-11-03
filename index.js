//import { Configuration, OpenAIApi } from "openai";
import OpenAI from 'openai';
import express from "express";
import bodyParser from "body-parser";
import cors from "cors";
import open from 'open';
import { createRequire } from 'module';

const require = createRequire(import.meta.url);

const openai = new OpenAI({
    apiKey: "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",
  });


const app = express();
const port = 8060;


app.use(bodyParser.json());
app.use(cors());

app.post("/", async (req, res) => {

    const {message} = req.body;
    const context = "You are a hotel (Hotel X) chatbot assistant. Here is the the only information you can provide: the hotel name is Hotel X, the price for renting a room is 50$ for a night, and there are 3 available rooms to book between 9am and 12pm.";
    //createChatCompletion is now chat.completions.create
    const chatCompletion = await openai.chat.completions.create({
        model: "gpt-3.5-turbo",
        messages: [
            {"role": "system", "content": `${context}`},
            {"role": "user", "content": `${message}`}
        ],
    });
    
    res.json({
        //new version is now console.log(chatCompletion.choices[0].message);
        completion: chatCompletion.choices[0].message
    });
});

open('index.html', { app: 'chrome' });

app.listen(port, () => {
    console.log('http://localhost:8060');
});

