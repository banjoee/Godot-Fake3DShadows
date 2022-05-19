# Godot-Fake3DShadows
Attempt to simulate 3D shadows on a 2D Environment. Currently in alpha state.

Basically the whole system works through the use of three scenes: Hurtboxes, Shadows and Area2Ds.
The `shadow.tscn` scene have a shader with the `shadowlength` parameter, that is controlled by the `distance = light_position.direction_to(global_position)` variable. This scene is instantiated by/inside the `hurtbox.tscn` everytime an Area2D node in the "light" group overlaps its own Area2D. My current problem revolves around "queue_freeing" the right instantiated shadows, since overlapping two or more "light" Area2Ds instantiates simultaneous shadow scenes, and I'm not able to keep track of each one of them.
Sorry about my code and folder organization being a little janky, that's because I'm still a beginner at Godot and coding in general.
