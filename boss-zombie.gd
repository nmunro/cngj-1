extends KinematicBody2D

var speed : int = 10
var velocity : Vector2 = Vector2()
var alive : bool = true
var jump_force : int = 300
var health : int = 100

onready var sprite : AnimatedSprite = get_node("AnimatedSprite")
onready var player : KinematicBody2D = get_node("../player")

func _ready():
	add_to_group("bosses")

func hit():
	if not alive:
		return
		
	health -= 1
	if health >= 0:
		die()
	
func attack(entity):
	if not alive:
		return
	
	get_node("attack-sound").play()
	sprite.play("attack")
	entity.die()
	sprite.stop()

func die():
	if not alive:
		return
		
	get_node("CollisionShape2D").disabled = true
	remove_from_group("bosses")
	alive = false
	get_node("die-sound").play()
	sprite.play("die")
	
func _process(_delta):
	if alive:
		sprite.play("walk")

func _physics_process(delta):
	if not alive:
		return
		
	velocity = move_and_slide(velocity, Vector2.UP)
	sprite.flip_h = position.x - player.position.x >= 0
	position = position.move_toward(Vector2(player.position.x, 560), delta * speed)
	
	for obj in get_slide_count():
		var collision = get_slide_collision(obj)

		if collision.collider.is_in_group("player"):
			attack(collision.collider)
