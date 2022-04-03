extends Spatial


export(PackedScene) var Cube

var delay = 2

var drop_area = 5

func _on_Timer_timeout():
    var cube = Cube.instance()
    cube.transform.origin = Vector3(randi()%drop_area-drop_area/2, 30, randi()%drop_area-drop_area/2)
    add_child(cube)
    delay *= 0.999
    $Timer.start(delay)
