extends CharacterBody2D

#just copied this from docs lol

var movement_speed: float = 200.0
var movement_target_position: Vector2 = Vector2.ZERO

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D


func _ready():
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0

	# Make sure to not await during _ready.
	call_deferred("actor_setup")

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(movement_target_position)

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

var new_velocity: Vector2 = Vector2.ZERO

func _physics_process(delta):
	set_movement_target(Globals.selectedProvincePosition)
	
	if navigation_agent.is_navigation_finished():
		return

	var next_path_position: Vector2 = navigation_agent.get_next_path_position()

	#new_velocity = next_path_position - global_position
	#new_velocity = new_velocity.normalized()
	#new_velocity = new_velocity * movement_speed

	set_velocity(new_velocity)

	move_and_slide()


func _on_navigation_agent_2d_link_reached(details):
	new_velocity = details.link_exit_position - global_position
	new_velocity = new_velocity.normalized()
	new_velocity = new_velocity * movement_speed
