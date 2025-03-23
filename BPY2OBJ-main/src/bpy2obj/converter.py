import bpy
import os
import tempfile
from typing import Dict, Any, Optional, BinaryIO, Tuple


class BpyToObjConverter:
    """
    Converts BPY (Blender Python) scripts to OBJ format.
    """
    
    def __init__(self):
        """Initialize the converter."""
        # Reset Blender to default state
        self.reset_blender()
        
    def reset_blender(self):
        """Reset Blender to a clean state."""
        # Clear existing objects
        bpy.ops.wm.read_factory_settings(use_empty=True)
        
        # Delete all objects
        if bpy.context.selected_objects:
            bpy.ops.object.delete()
            
        # Remove all data blocks
        for block in bpy.data.meshes:
            bpy.data.meshes.remove(block)
        for block in bpy.data.materials:
            bpy.data.materials.remove(block)
        for block in bpy.data.textures:
            bpy.data.textures.remove(block)
        for block in bpy.data.images:
            bpy.data.images.remove(block)
    
    def execute_bpy_script(self, script_content: str) -> Dict[str, Any]:
        """
        Execute a BPY script and return information about the resulting scene.
        
        Args:
            script_content: String containing the BPY script
            
        Returns:
            Dict with information about the executed script and any errors
        """
        self.reset_blender()
        
        result = {
            "success": False,
            "error": None,
            "object_count": 0,
            "objects": []
        }
        
        try:
            # Execute the script
            exec(script_content)
            
            # Gather information about the scene
            result["success"] = True
            result["object_count"] = len(bpy.context.scene.objects)
            result["objects"] = [obj.name for obj in bpy.context.scene.objects]
            
        except Exception as e:
            result["error"] = str(e)
            
        return result
    
    def convert_script_to_obj(self, script_content: str) -> Tuple[Optional[bytes], Optional[str]]:
        """
        Convert a BPY script to OBJ format.
        
        Args:
            script_content: String containing the BPY script
            
        Returns:
            Tuple containing (obj_data_bytes, error_message)
            If successful, obj_data_bytes will contain the OBJ file data and error_message will be None
            If an error occurs, obj_data_bytes will be None and error_message will contain the error
        """
        # Execute the script
        result = self.execute_bpy_script(script_content)
        
        if not result["success"]:
            return None, result["error"]
        
        if result["object_count"] == 0:
            return None, "No objects created by the script"
        
        # Export to OBJ
        try:
            # Create a temporary file for the OBJ export
            with tempfile.NamedTemporaryFile(suffix=".obj", delete=False) as temp_file:
                temp_path = temp_file.name
            
            # Export to OBJ format
            bpy.ops.export_scene.obj(
                filepath=temp_path,
                use_selection=False,
                use_materials=True,
                use_triangles=False,
                use_normals=True
            )
            
            # Read the OBJ file
            with open(temp_path, 'rb') as f:
                obj_data = f.read()
                
            # Clean up
            os.unlink(temp_path)
            
            return obj_data, None
            
        except Exception as e:
            return None, f"Error exporting to OBJ: {str(e)}" 