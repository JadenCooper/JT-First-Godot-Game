extends Spatial

onready var camera = $"../Camera"
onready var Commander = $Commander
onready var Units = [$Unit_1,$Unit_2,$Unit_3]


func _process(delta):                                                          # This runs all its units main functions,
	Find_mouse_position(delta)                                                 # First find the mouse position on map and check input,
	Commander.Action(delta)                                                    # Run Commander main functions,
	var i = 0
	for A in Units:                                                            # For every unit, run main functions and give that unit its position to follow.
		A.Action(delta,Commander.Positions[i].global_translation)
		i += 1



func Find_mouse_position(delta):
	var mouse_pos = get_viewport().get_mouse_position()                        # Get mouse position and shoot a ray from it downwards and see if it intersects
																			   # with anything, if so check if input is pressed, if yes set a new target for
	ray_origin = camera.project_ray_origin(mouse_pos)                          # the Commander.
	ray_target = ray_origin + camera.project_ray_normal(mouse_pos) * 2000
	
	var space_state = get_world().direct_space_state
	var intersection = space_state.intersect_ray(ray_origin, ray_target)
	
	if not intersection.empty() and Input.is_action_just_pressed("Left Click"):
		Commander.agent.set_target_location(intersection.position)

var ray_origin = Vector3()
var ray_target = Vector3()
