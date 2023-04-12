extends KinematicBody

onready var agent = $NavigationAgent

export var SPEED = 100
export var MAX_SPEED = 20
export var DECELERATION = 100
export var ROTATION_SPEED = 10

var motion = Vector3.ZERO

func _physics_process(delta): motion = move_and_slide(motion)

func Action(delta, target):
	if global_translation.distance_to(target) <= agent.target_desired_distance: idle(delta)
	else: move(delta, target)

func move(delta, target):
	agent.set_target_location(target)
	var next = agent.get_next_location()
	var direc = global_translation.direction_to(next)
	rotation.y = lerp_angle(rotation.y, atan2(-direc.x, -direc.z), delta * ROTATION_SPEED)
	motion += (next - global_translation).normalized() * SPEED * delta
	motion = motion.limit_length(MAX_SPEED)

func idle(delta):
	if motion.length() > DECELERATION * delta:
		  motion -= motion.normalized() * DECELERATION * delta
	else: motion = Vector3.ZERO
