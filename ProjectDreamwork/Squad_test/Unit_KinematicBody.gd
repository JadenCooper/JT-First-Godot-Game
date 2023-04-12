extends KinematicBody

onready var agent = $NavigationAgent                                           # agent node allows for communication to the Navigation mesh

onready var Positions = [$Position1,$Position2,$Position3]

export var SPEED = 100
export var MAX_SPEED = 20
export var DECELERATION = 100
export var ROTATION_SPEED = 3

var motion = Vector3.ZERO

func _physics_process(delta): motion = move_and_slide(motion)                  # Moves kinematic body by motion every physics update

func Action(delta):                                                            # Updates motion if destination not reached, else run idle
	if agent.is_target_reached(): idle(delta)
	else: move(delta)

func move(delta):                                                              # First calculate direction to the next point on path to destination
	var next = agent.get_next_location()                                       # Then rotate self, and update motion so that it is going towards next point multiplied by SPEED,
	var direc = global_translation.direction_to(next)                          # Finally limet how high a Vector motion can be by MAXSPEED
	rotation.y = lerp_angle(rotation.y, atan2(-direc.x, -direc.z), delta * ROTATION_SPEED)
	motion += (next - global_translation).normalized() * SPEED * delta
	motion = motion.limit_length(MAX_SPEED)

func idle(delta):                                                              # Applys friction to motion
	if motion.length() > DECELERATION * delta:                                 
		  motion -= motion.normalized() * DECELERATION * delta
	else: motion = Vector3.ZERO
