from fastapi import FastAPI, Query, Body, File, UploadFile
from fastapi.staticfiles import StaticFiles
from fastapi.responses import RedirectResponse


app = FastAPI()
app.mount("/front", StaticFiles(directory="frontend/dist"), name="front")
app.mount(
    "/static", StaticFiles(directory="frontend/dist/static"), name="static"
)  # must be '/static'


@app.get("/hello")
async def hello():
    print({"Hello": "World!!!"})
    return {"Hello": "World!!!"}


@app.post("/post")
async def echo(type: str, name: str = Query(None), body: dict = Body(None)):
    print({"type": type, "name": name, "body": body})
    return {"type": type, "name": name, "body": body}


@app.post("/upload")
async def upload(file: UploadFile = File(...)):
    code = 0
    message = "success"
    try:
        print("uploaded:", file.filename)
        contents = await file.read()
        print("contents:", contents.decode('utf-8')[:100])
    except Exception as e:
        print("Exception:", e)
        code = 1
        message = str(e)
    finally:
        return {"code": code, "message": message, "description": f"upload file '{file.filename}'"}


@app.get("/")
async def redirect_index_html():
    return RedirectResponse("front/index.html")


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
