extends Spatial


export(PackedScene) var Platform


func _process(delta):
    var players = get_tree().get_nodes_in_group("Player")
    if len(players) > 0:
        if players[0].dead:
            $AudioStreamPlayer.stop()

func _ready():
    randomize()
    init_platforms(Global.level_radius)
    
    
func init_platforms(radius):
    for x in range(-radius, radius+1):
        var row = ""
        for z in range(-radius, radius+1):
            if Vector2(x,z).length() <= radius+0.2:
                add_platform(x,z)
                row += "#"
            else:
                row += " "

func add_platform(x,z):
    var platform = Platform.instance()
    var pd = Global.platform_distance
    if randi()%9:
        platform.transform.origin = Vector3(x*pd, 1.5+randf()/2.0, z*pd)
    else:
        platform.transform.origin = Vector3(x*pd, -1.5+randf()*2.0, z*pd)
    add_child(platform)
