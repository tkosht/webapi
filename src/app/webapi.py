from fastapi import FastAPI, Query, Body
from fastapi.staticfiles import StaticFiles
from fastapi.responses import RedirectResponse


app = FastAPI()
app.mount("/front", StaticFiles(directory="frontend/dist"), name="front")
app.mount(
    "/static", StaticFiles(directory="frontend/dist/static"), name="static"
)  # must be '/static'


@app.get("/hello")
def hello():
    print({"Hello": "World!!!"})
    return {"Hello": "World!!!"}


@app.post("/post")
def echo(type: str, name: str = Query(None), body: dict = Body(None)):
    print({"type": type, "name": name, "body": body})
    return {"type": type, "name": name, "body": body}


@app.get("/")
async def redirect_index_html():
    return RedirectResponse("front/index.html")
