import sys
import subprocess
import json
from http.server import HTTPServer, BaseHTTPRequestHandler
import tempfile
import os
import traceback

def create_blender_script(script_content, output_path):
    """Create a complete Blender script that includes the necessary imports and export code"""
    return f"""
import bpy

# Clear existing objects
bpy.ops.wm.read_factory_settings(use_empty=True)
for obj in bpy.data.objects:
    bpy.data.objects.remove(obj, do_unlink=True)

# Execute the user's script
{script_content}

# Export to OBJ
bpy.ops.export_scene.obj(
    filepath="{output_path}",
    use_selection=False,
    use_materials=True,
    use_triangles=False,
    use_normals=True
)
"""

def run_blender_script(script_content):
    # Create a temporary file for the script
    with tempfile.NamedTemporaryFile(mode='w', suffix='.py', delete=False) as temp_script:
        # Create temporary output path
        output_path = os.path.join(tempfile.gettempdir(), "output.obj")
        # Create the complete script with export
        complete_script = create_blender_script(script_content, output_path)
        temp_script.write(complete_script)
        script_path = temp_script.name

    try:
        # Run Blender in background mode with Python script
        blender_path = "/Applications/Blender.app/Contents/MacOS/Blender"
        if not os.path.exists(blender_path):
            raise Exception(f"Blender not found at {blender_path}. Please install Blender.")
            
        blender_cmd = [
            blender_path,
            '--background',
            '--python', script_path
        ]
        
        print(f"Running Blender command: {' '.join(blender_cmd)}")
        result = subprocess.run(blender_cmd, capture_output=True, text=True)
        print("Blender output:", result.stdout)
        print("Blender errors:", result.stderr)
        
        if result.returncode != 0:
            raise Exception(f"Blender error: {result.stderr}")
            
        if not os.path.exists(output_path):
            raise Exception("No output file was generated")
            
        with open(output_path, 'rb') as f:
            obj_data = f.read()
            
        return obj_data
        
    finally:
        # Clean up temporary files
        if os.path.exists(script_path):
            os.unlink(script_path)
        if os.path.exists(output_path):
            try:
                os.unlink(output_path)
            except:
                pass

class BPYServer(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/health':
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            response = {
                "status": "healthy",
                "message": "Server is running"
            }
            self.wfile.write(json.dumps(response).encode())
        else:
            self.send_response(404)
            self.end_headers()
            self.wfile.write(b"Not found")

    def do_POST(self):
        if self.path == '/convert':
            try:
                # Read the request body
                content_length = int(self.headers.get('Content-Length', 0))
                if content_length == 0:
                    raise ValueError("Empty request body")
                
                post_data = self.rfile.read(content_length)
                print(f"Received raw data: {post_data[:100]}...")
                
                try:
                    request_data = json.loads(post_data.decode('utf8'))
                except json.JSONDecodeError as e:
                    print(f"JSON decode error: {str(e)}")
                    raise ValueError(f"Invalid JSON data: {str(e)}")
                
                if not isinstance(request_data, dict):
                    raise ValueError("Request data must be a JSON object")
                
                if 'script' not in request_data:
                    raise ValueError("No script provided in request")
                
                script = request_data['script']
                if not isinstance(script, str):
                    raise ValueError("Script must be a string")
                
                print(f"Processing script: {script[:100]}...")
                
                # Process the script with Blender
                obj_data = run_blender_script(script)
                
                # Send response
                self.send_response(200)
                self.send_header('Content-type', 'application/octet-stream')
                self.send_header('Content-Disposition', 'attachment; filename=model.obj')
                self.end_headers()
                self.wfile.write(obj_data)
                print("Response sent successfully")
                
            except Exception as e:
                print(f"Error occurred: {str(e)}")
                print("Traceback:")
                traceback.print_exc()
                self.send_response(400)
                self.send_header('Content-type', 'application/json')
                self.end_headers()
                error_response = {"error": str(e)}
                self.wfile.write(json.dumps(error_response).encode())
        else:
            self.send_response(404)
            self.end_headers()
            self.wfile.write(b"Not found")

def run_server(port=8000):
    server_address = ('', port)
    try:
        httpd = HTTPServer(server_address, BPYServer)
        print(f"Server running on port {port}...")
        httpd.serve_forever()
    except OSError as e:
        if e.errno == 48:  # Address already in use
            print(f"Error: Port {port} is already in use. Please stop any existing server first.")
        else:
            print(f"Error starting server: {e}")
    except KeyboardInterrupt:
        print("\nShutting down server...")
        httpd.server_close()

if __name__ == "__main__":
    # Verify Blender exists
    blender_path = "/Applications/Blender.app/Contents/MacOS/Blender"
    if not os.path.exists(blender_path):
        print(f"Error: Blender not found at {blender_path}")
        print("Please make sure Blender is installed in the Applications folder")
        sys.exit(1)
    run_server() 