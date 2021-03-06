extends StaticBody

onready var areaCollider = $Area
var numOfObjects = 0
var distanceTraveled = 0
var player_on = false
export(float) var verticalVelocity = 1
export(float) var distanceTillSunk = 15

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    _move_down(numOfObjects, delta)
    if _checkIfSunken():
        _destroy()

func _move_down(objectCount, delta):
    var moveBy = -0.2 * objectCount * delta
    if player_on:
        var player = get_tree().get_nodes_in_group("Player")[0]
        moveBy -= 0.2 * (1 + player.orb_value) * delta
    translate(Vector3(0, moveBy, 0))
    distanceTraveled += abs(moveBy)

func _checkIfSunken():
    if transform.origin.y < -2.1:
        return true
    else:
        return false                    

func _destroy():
    queue_free()

func _on_Area_body_entered(body):
    if body.is_in_group("Weight"):
        numOfObjects += 1
    if body.is_in_group("Player"):
        player_on = true


func _on_Area_body_exited(body):
    if body.is_in_group("Weight"):
        numOfObjects -= 1
    if body.is_in_group("Player"):
        player_on = false
