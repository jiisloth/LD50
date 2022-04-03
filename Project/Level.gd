extends Spatial


export(PackedScene) var Platform


func _ready():
    init_platforms(5)
    
    
func init_platforms(radius):
    for x in range(-radius, radius+1):
        var row = ""
        for z in range(-radius, radius+1):
            if Vector2(x,z).length() <= radius+0.5:
                add_platform(x,z)
                row += "#"
            else:
                row += " "
        print(row)

func add_platform(x,z):
    var platform = Platform.instance()
    if randi()%9:
        platform.transform.origin = Vector3(x*5.2, 1.5+randf()/2.0, z*5.2)
    else:
        platform.transform.origin = Vector3(x*5.2, -1.5+randf()*2.0, z*5.2)
    add_child(platform)
