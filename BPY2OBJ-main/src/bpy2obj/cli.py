#!/usr/bin/env python3
import argparse
from .api import start_server

def main():
    parser = argparse.ArgumentParser(description="BPY to OBJ Converter API Server")
    parser.add_argument("--host", type=str, default="0.0.0.0", help="Host to bind the server to")
    parser.add_argument("--port", type=int, default=8000, help="Port to bind the server to")
    parser.add_argument("--debug", action="store_true", help="Enable debug mode")
    
    args = parser.parse_args()
    
    print(f"Starting BPY to OBJ Converter API Server on {args.host}:{args.port}")
    print(f"Debug mode: {'enabled' if args.debug else 'disabled'}")
    
    start_server(host=args.host, port=args.port, debug=args.debug)

if __name__ == "__main__":
    main() 