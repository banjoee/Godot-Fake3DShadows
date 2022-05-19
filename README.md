# Godot-Fake3DShadows
Attempt to simulate 3D shadows on a 2D Environment. Currently in alpha state.

Basically the whole system works through the use of three scenes: Hurtboxes, Shadows and Light2Ds.
The `shadow.tscn` scene have a shader with the `shadowlength` parameter that is controlled by the `distance _(light_position.direction_to(global_position))_` variable. This scene is attached to the `entity_base.tscn`
