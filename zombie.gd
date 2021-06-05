extends KinematicBody2D

var speed : int = 10
var velocity : Vector2 = Vector2()
var alive : bool = true
var jump_force : int = 300

onready var sprite : AnimatedSprite = get_node("AnimatedSprite")
onready var player : KinematicBody2D = get_node("../player")

func _ready():
	add_to_group("enemies")

func _process(_delta):
	if alive:
		sprite.play("walk")
	
func die():
	get_node("CollisionShape2D").disabled = true
	remove_from_group("enemies")
	alive = false
	get_node("die-sound").play()
	sprite.play("die")
	
func attack(entity):
	get_node("attack-sound").play()
	sprite.play("attack")
	entity.die()
	sprite.stop()

func _physics_process(delta):
	if not alive:
		return
		
	velocity = move_and_slide(velocity, Vector2.UP)
	sprite.flip_h = position.x - player.position.x >= 0
	position = position.move_toward(Vector2(player.position.x, 560), delta * speed)
	
	if not is_on_floor():
		velocity.y += jump_force
	
	for obj in get_slide_count():
		var collision = get_slide_collision(obj)

		if collision.collider.is_in_group("player"):
			attack(collision.collider)
