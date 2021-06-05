extends KinematicBody2D

var score : int = 0
var speed : int = 200
var jump_force : int = 600
var gravity : int = 800
var velocity : Vector2 = Vector2()
var alive : bool = true

onready var sprite : AnimatedSprite = get_node("AnimatedSprite")
onready var Weapon = preload("res://weapon.tscn")

func _ready():
	add_to_group("player")

func _process(_delta):
	if not alive:
		return
		
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		sprite.play("run")
		
	elif not is_on_floor():
		sprite.play("jump")
		
	elif Input.is_action_just_pressed("attack"):
		attack()
		
	else:
		sprite.play("idle")
		
func die():
	alive = false
	get_node("die-sound").play()
	sprite.play("die")
	yield(sprite, "animation_finished")
	get_tree().change_scene("res://gameover.tscn")
	
func attack():
	var weapon = Weapon.instance()
	var pos = Vector2(position.x - 50 if sprite.flip_h else position.x + 50, position.y)
	
	weapon.transform = transform
	weapon.start(pos, rotation, sprite.flip_h)
	get_parent().add_child(weapon)
	sprite.play("attack")

func _physics_process(delta):
	if not alive:
		return 
		
	velocity.x = 0
	
	if Input.is_action_pressed("move_left"):
		velocity.x -= speed
		
	if Input.is_action_pressed("move_right"):
		velocity.x += speed
		
	velocity = move_and_slide(velocity, Vector2.UP)
	
	for obj in get_slide_count():
		var collision = get_slide_collision(obj)
		if collision.collider.is_in_group("enemies"):
			die()
			
		elif collision.collider.is_in_group("exit"):
			if collision.collider.name == "exit1":
				get_tree().change_scene("res://level2.tscn")
				
			elif collision.collider.name == "exit2":
				get_tree().change_scene("res://level3.tscn")
			
			elif collision.collider.name == "exit3":
				get_tree().change_scene("res://level4.tscn")
				
			elif collision.collider.name == "exit4":
				get_tree().change_scene("res://level5.tscn")
			
			elif collision.collider.name == "exit5":
				get_tree().change_scene("res://boss.tscn")
				
			elif collision.collider.name == "exit6":
				get_tree().change_scene("res://victory.tscn")
							
			get_node("music").stop()
	
	velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y -= jump_force
	
	if velocity.x < 0:
		sprite.flip_h = true
		
	elif velocity.x > 0:
		sprite.flip_h = false
