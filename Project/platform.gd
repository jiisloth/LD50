extends StaticBody

onready var areaCollider = $Area
var numOfObjects = 0
var distanceTraveled = 0
export(float) var verticalVelocity = 1
export(float) var distanceTillSunk = 10

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    _move_down(numOfObjects, delta)
    if _checkIfSunken():
        _destroy()
    pass

func _move_down(objectCount, delta):
    var moveBy = -2 * objectCount * delta
    translate(Vector3(0, moveBy, 0))
    distanceTraveled += abs(moveBy)
    pass

func _checkIfSunken():
    if distanceTraveled >= distanceTillSunk:
        return true
    else:
        return false                    

func _destroy():
    queue_free()

func _on_Area_body_entered(body):
    if body.is_in_group("Weight"):
        numOfObjects += 1


func _on_Area_body_exited(body):
    if body.is_in_group("Weight"):
        numOfObjects -= 1
