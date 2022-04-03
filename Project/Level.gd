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
    platform.transform.origin = Vector3(x*4.1, 1.5, z*4.1)
    add_child(platform)
