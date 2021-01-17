from fastapi import FastAPI, Query, Body


app = FastAPI()


@app.get("/hello")
def hello():
    return {"Hello": "World!!!"}


@app.post("/post")
def predict(type: str, name: str = Query(None), body: dict = Body(None)):
    return {"type": type, "name": name, "body": body}
