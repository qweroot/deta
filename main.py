import os, json, time, urllib.parse
from fastapi import FastAPI
from pydantic import BaseModel
from playwright.sync_api import sync_playwright

app = FastAPI()

class SolveReq(BaseModel):
    sitekey: str
    siteurl: str

@app.post("/solve")
def solve(req: SolveReq):
    token = None
    try:
        with sync_playwright() as p:
            browser = p.chromium.launch(headless=True, args=[
                "--no-sandbox", 
                "--disable-blink-features=AutomationControlled",
                "--disable-dev-shm-usage"
            ])
            page = browser.new_page()
            page.goto(req.siteurl, timeout=60000)
            
            for _ in range(20):
                token = page.evaluate('document.querySelector(\'[name="cf-turnstile-response"]\')?.value')
                if token and len(token) > 20:
                    break
                time.sleep(1)
            browser.close()
    except Exception as e:
        return {"error": str(e)}
        
    if token:
        return {"token": token}
    return {"error": "failed to get token"}

@app.get("/health")
def health(): return {"status": "ok"}
