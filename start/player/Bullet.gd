extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 60
var velocity = Vector3()

onready var timer = get_node("Timer")
# Called when the node enters the scene tree for the first time.
func _ready():
	timer.set_wait_time(1)
	timer.start()

func start(xform):
	transform = xform
	velocity = transform.basis.y *speed

func _process(delta):
	transform.origin += velocity * delta
	pass
	
func _on_Bullet_body_entered(body):
	print("Bullet collided")
	if body is StaticBody:
		print("here")
		#queue_free()
		
func _on_Timer_timeout():
	queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
