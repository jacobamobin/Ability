# BPY2OBJ

An API for converting Blender Python (BPY) scripts to OBJ 3D model files.

## Overview

This API service allows you to convert Blender Python (BPY) scripts into standard OBJ 3D model files. It provides a simple API interface that executes the BPY script in a controlled Blender environment and exports the resulting 3D models to OBJ format.

## Requirements

- Python 3.7+
- Blender 3.6+ with Python support
- Dependencies listed in `requirements.txt`

## Installation

### From Source

```bash
git clone https://github.com/yourusername/bpy2obj.git
cd bpy2obj
pip install -e .
```

## Usage

### Starting the Server

```bash
bpy2obj-server --host 0.0.0.0 --port 8000 --debug
```

Or run it directly:

```bash
python -m bpy2obj.cli
```

### API Endpoints

#### `GET /`

Returns basic information about the API.

#### `POST /validate`

Validates a BPY script without producing an OBJ file.

**Request Parameters:**
- `script`: The BPY script as a string (form data)

**Response:**
```json
{
  "valid": true,
  "object_count": 1,
  "objects": ["Cube"]
}
```

#### `POST /convert`

Converts a BPY script to OBJ format and returns the OBJ file.

**Request Parameters:**
- `script`: The BPY script as a string (form data)
- `filename`: (Optional) Filename for the downloaded OBJ file (form data, default: "model.obj")

**Response:**
- OBJ file as a downloadable attachment

#### `POST /convert/base64`

Converts a BPY script to OBJ format and returns base64-encoded data.

**Request Parameters:**
- `script`: The BPY script as a string (form data)

**Response:**
```json
{
  "format": "obj",
  "base64_data": "..."
}
```

## Example BPY Script

Here's a simple example of a BPY script that creates a cube:

```python
import bpy

# Clear existing objects
bpy.ops.object.select_all(action='SELECT')
bpy.ops.object.delete()

# Create a cube
bpy.ops.mesh.primitive_cube_add(size=2, location=(0, 0, 0))
```

## License

MIT 