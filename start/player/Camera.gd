extends Camera


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 1
var velocity = Vector3()
var zoomedIn = false
func zoomIn(xform):
	translate(Vector3(0,0,-speed))
	zoomedIn = true

func zoomOut(xform):
	translate(Vector3(0,0,speed))

