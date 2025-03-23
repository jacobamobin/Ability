import bpy

# Clear existing objects
bpy.ops.wm.read_factory_settings(use_empty=True)
for obj in bpy.data.objects:
    bpy.data.objects.remove(obj, do_unlink=True)

# Add a cube
bpy.ops.mesh.primitive_cube_add(size=2, location=(0, 0, 0))

# Export to OBJ
bpy.ops.export_scene.obj(
    filepath="test_output.obj",
    use_selection=False,
    use_materials=True,
    use_triangles=False,
    use_normals=True
) 