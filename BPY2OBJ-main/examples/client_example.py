#!/usr/bin/env python3
import requests
import base64
import sys
import argparse

def main():
    parser = argparse.ArgumentParser(description="BPY2OBJ API Client Example")
    parser.add_argument("--host", type=str, default="localhost", help="API host")
    parser.add_argument("--port", type=int, default=8000, help="API port")
    parser.add_argument("--script", type=str, help="Path to BPY script file")
    parser.add_argument("--output", type=str, default="model.obj", help="Output OBJ file path")
    parser.add_argument("--validate-only", action="store_true", help="Only validate the script without generating OBJ")
    parser.add_argument("--base64", action="store_true", help="Get base64 encoded response instead of binary file")
    
    args = parser.parse_args()
    
    if not args.script:
        print("Error: Please provide a script file using --script")
        sys.exit(1)
    
    # Read the script file
    try:
        with open(args.script, 'r') as f:
            script_content = f.read()
    except Exception as e:
        print(f"Error reading script file: {e}")
        sys.exit(1)
    
    # API base URL
    base_url = f"http://{args.host}:{args.port}"
    
    # Validate only mode
    if args.validate_only:
        response = requests.post(
            f"{base_url}/validate",
            data={"script": script_content}
        )
        
        if response.status_code == 200:
            result = response.json()
            if result.get("valid", False):
                print("✅ Script is valid!")
                print(f"Objects created: {result.get('object_count', 0)}")
                print(f"Object names: {', '.join(result.get('objects', []))}")
            else:
                print("❌ Script is invalid!")
                print(f"Error: {result.get('error', 'Unknown error')}")
        else:
            print(f"❌ Error: {response.status_code}")
            print(response.text)
        
        sys.exit(0)
    
    # Base64 mode
    if args.base64:
        response = requests.post(
            f"{base_url}/convert/base64",
            data={"script": script_content}
        )
        
        if response.status_code == 200:
            result = response.json()
            base64_data = result.get("base64_data", "")
            
            # Decode and save to file
            try:
                obj_data = base64.b64decode(base64_data)
                with open(args.output, 'wb') as f:
                    f.write(obj_data)
                print(f"✅ OBJ file saved to {args.output}")
            except Exception as e:
                print(f"❌ Error saving OBJ file: {e}")
        else:
            print(f"❌ Error: {response.status_code}")
            print(response.text)
        
        sys.exit(0)
    
    # Direct download mode
    response = requests.post(
        f"{base_url}/convert",
        data={"script": script_content, "filename": args.output}
    )
    
    if response.status_code == 200:
        try:
            with open(args.output, 'wb') as f:
                f.write(response.content)
            print(f"✅ OBJ file saved to {args.output}")
        except Exception as e:
            print(f"❌ Error saving OBJ file: {e}")
    else:
        print(f"❌ Error: {response.status_code}")
        print(response.text)

if __name__ == "__main__":
    main() 