import bpy

# Clear existing objects
bpy.ops.object.select_all(action='SELECT')
bpy.ops.object.delete()

# Create a cube
bpy.ops.mesh.primitive_cube_add(size=2, location=(0, 0, 0))

# Add a material
material = bpy.data.materials.new(name="CubeMaterial")
material.diffuse_color = (0.8, 0.2, 0.2, 1.0)  # Red color with alpha=1

# Assign the material to the cube
cube = bpy.context.active_object
if cube.data.materials:
    cube.data.materials[0] = material
else:
    cube.data.materials.append(material) 