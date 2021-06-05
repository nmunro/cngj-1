extends KinematicBody2D

var speed : int = 250
var direction_left : bool = true
var velocity : Vector2 = Vector2()

func _ready():
	add_to_group("weapons")

func start(pos, rot, move_left):
	rotation = rot
	position = pos
	direction_left = move_left
	velocity = Vector2(speed, 0).rotated(rotation)

func _physics_process(delta):
	var pos = 0
	
	if direction_left:
		pos -= speed
	
	else:
		pos += speed
		
	var collision = move_and_collide(Vector2(pos, 0) * delta)
	
	if not collision:
		return
		
	if collision.collider.is_in_group("enemies"):
		collision.collider.die()
	
	elif collision.collider.is_in_group("bosses"):
		collision.collider.hit()
	queue_free()
