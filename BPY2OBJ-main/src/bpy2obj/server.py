import sys
import os
import bpy
import uvicorn
from fastapi import FastAPI, HTTPException
from fastapi.responses import Response
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

# Add the project root to Python path
sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))

from bpy2obj.converter import BpyToObjConverter

app = FastAPI(title="BPY2OBJ API")

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
)

converter = BpyToObjConverter()

class BpyScript(BaseModel):
    script: str

@app.post("/convert")
async def convert_bpy_to_obj(script_data: BpyScript):
    """Convert a BPY script to OBJ format."""
    obj_data, error = converter.convert_script_to_obj(script_data.script)
    
    if error:
        raise HTTPException(status_code=400, detail=error)
        
    return Response(
        content=obj_data,
        media_type="application/octet-stream",
        headers={"Content-Disposition": "attachment; filename=model.obj"}
    )

@app.get("/health")
async def health_check():
    """Health check endpoint."""
    return {"status": "healthy"}

if __name__ == "__main__":
    # Get command line arguments passed after --
    argv = sys.argv
    try:
        index = argv.index("--") + 1
        args = argv[index:]
    except ValueError:
        args = []

    # Parse host and port
    host = "127.0.0.1"
    port = 8000
    
    for i in range(0, len(args), 2):
        if args[i] == "--host":
            host = args[i + 1]
        elif args[i] == "--port":
            port = int(args[i + 1])

    uvicorn.run(app, host=host, port=port) 