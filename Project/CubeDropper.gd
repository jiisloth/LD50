extends Spatial


export(PackedScene) var Cube
export(PackedScene) var Orb

var delay = 1.1

var drop_area = 52
var orb_drops = []


func _ready():
    drop_area = Global.level_radius * Global.platform_distance * 2
    set_orb_drops(Global.level_radius)

func _on_Timer_timeout():
    drop()
    delay *= 0.999
    $Timer.start(delay)
    

func drop():
    var cube = Cube.instance()
    var drop_point = Vector2(randf()*drop_area-drop_area/2,randf()*drop_area-drop_area/2)
    while drop_point.length() > drop_area/2:
        drop_point = Vector2(randf()*drop_area-drop_area/2,randf()*drop_area-drop_area/2)
    cube.transform.origin = Vector3(drop_point.x, 30, drop_point.y)
    cube.rotation_degrees = Vector3(randi()%360,randi()%360,randi()%360)
    add_child(cube)
    
func set_orb_drops(radius):
    for x in range(-radius, radius+1):
        for z in range(-radius, radius+1):
            if Vector2(x,z).length() <= radius+0.2:
                orb_drops.append(Vector2(x,z)*Global.platform_distance)

func _on_Timer2_timeout():
    var orb = Orb.instance()
    var drop_point = orb_drops[randi()%len(orb_drops)] + Vector2(randf()*2.0-1.0,randf()*2.0-1.0)
    orb.transform.origin = Vector3(drop_point.x, 30, drop_point.y)
    add_child(orb)
