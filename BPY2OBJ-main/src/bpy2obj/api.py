from fastapi import FastAPI, HTTPException, UploadFile, File, Form
from fastapi.responses import Response, JSONResponse
import uvicorn
from io import BytesIO
import base64
from typing import Optional, Dict, Any

from .converter import BpyToObjConverter

app = FastAPI(
    title="BPY to OBJ Converter API",
    description="API for converting Blender Python (BPY) scripts to OBJ 3D models",
    version="1.0.0",
)

# Create a single converter instance to be reused
converter = BpyToObjConverter()


@app.get("/")
async def root():
    """Root endpoint that returns API information."""
    return {
        "name": "BPY to OBJ Converter API",
        "version": "1.0.0",
        "endpoints": [
            {"path": "/", "method": "GET", "description": "This information"},
            {"path": "/convert", "method": "POST", "description": "Convert BPY script to OBJ"},
            {"path": "/validate", "method": "POST", "description": "Validate BPY script without OBJ conversion"},
        ]
    }


@app.post("/convert")
async def convert_bpy_to_obj(
    script: str = Form(...),
    filename: str = Form("model.obj")
):
    """
    Convert a BPY script to OBJ format
    
    Parameters:
    - script: The BPY script content as string
    - filename: Optional filename for the downloaded OBJ file
    
    Returns:
    - OBJ file as downloadable attachment
    """
    obj_data, error = converter.convert_script_to_obj(script)
    
    if error:
        raise HTTPException(status_code=400, detail=error)
    
    return Response(
        content=obj_data,
        media_type="application/octet-stream",
        headers={"Content-Disposition": f"attachment; filename={filename}"}
    )


@app.post("/convert/base64")
async def convert_bpy_to_obj_base64(script: str = Form(...)):
    """
    Convert a BPY script to OBJ format and return base64-encoded data
    
    Parameters:
    - script: The BPY script content as string
    
    Returns:
    - JSON with base64 encoded OBJ data
    """
    obj_data, error = converter.convert_script_to_obj(script)
    
    if error:
        raise HTTPException(status_code=400, detail=error)
    
    base64_data = base64.b64encode(obj_data).decode('utf-8')
    
    return JSONResponse({
        "format": "obj",
        "base64_data": base64_data
    })


@app.post("/validate")
async def validate_bpy_script(script: str = Form(...)):
    """
    Validate a BPY script without exporting to OBJ
    
    Parameters:
    - script: The BPY script content as string
    
    Returns:
    - JSON with validation results
    """
    result = converter.execute_bpy_script(script)
    
    if not result["success"]:
        return JSONResponse({
            "valid": False,
            "error": result["error"]
        })
    
    return JSONResponse({
        "valid": True,
        "object_count": result["object_count"],
        "objects": result["objects"]
    })


def start_server(host: str = "0.0.0.0", port: int = 8000, debug: bool = False):
    """Start the API server."""
    uvicorn.run("src.bpy2obj.api:app", host=host, port=port, reload=debug)


if __name__ == "__main__":
    start_server(debug=True) 