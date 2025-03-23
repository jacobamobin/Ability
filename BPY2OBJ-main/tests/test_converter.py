import unittest
import sys
import os

# Add the src directory to the path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../src')))

from bpy2obj.converter import BpyToObjConverter

class TestBpyToObjConverter(unittest.TestCase):
    
    def setUp(self):
        self.converter = BpyToObjConverter()
        
        # Simple BPY script that creates a cube
        self.cube_script = """
import bpy

# Clear existing objects
bpy.ops.object.select_all(action='SELECT')
bpy.ops.object.delete()

# Create a cube
bpy.ops.mesh.primitive_cube_add(size=2, location=(0, 0, 0))
"""
        
        # Invalid BPY script with syntax error
        self.invalid_script = """
import bpy

# This has a syntax error
if True
    bpy.ops.mesh.primitive_cube_add()
"""

    def test_execute_valid_script(self):
        result = self.converter.execute_bpy_script(self.cube_script)
        self.assertTrue(result["success"])
        self.assertEqual(result["object_count"], 1)
        
    def test_execute_invalid_script(self):
        result = self.converter.execute_bpy_script(self.invalid_script)
        self.assertFalse(result["success"])
        self.assertIsNotNone(result["error"])
        
    def test_convert_to_obj(self):
        obj_data, error = self.converter.convert_script_to_obj(self.cube_script)
        self.assertIsNone(error)
        self.assertIsNotNone(obj_data)
        
        # Check that the OBJ file contains vertices and faces
        obj_text = obj_data.decode('utf-8')
        self.assertIn("v ", obj_text)  # Vertices
        self.assertIn("f ", obj_text)  # Faces
        
if __name__ == "__main__":
    unittest.main() 