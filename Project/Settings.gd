extends VBoxContainer


var default = {
    "music": 75,
    "sfx": 75,
    "mouse": 32,
    "fov": 70
   }
var save 

func _ready():
    read_save()

func read_save():
    var file = File.new()
    if not file.file_exists(Global.savepath):
        init_save()
        
    file.open(Global.savepath, File.READ)
    save = parse_json(file.get_as_text())
    file.close()
    $MusicSlider.value = save["music"]
    $SFXSlider.value = save["sfx"]
    $MouseSlider.value = save["mouse"]
    $FOVSlider.value = save["fov"]


func init_save():
    var file = File.new()
    file.open(Global.savepath, File.WRITE)
    file.store_line(to_json(default))
    file.close()
    

func save_game():
    var file = File.new()
    file.open(Global.savepath, File.WRITE)
    file.store_line(to_json(save))
    file.close()
    

func _on_MusicSlider_value_changed(value):
    $MusicLabel/Value.text = str(value) + "%"
    save["music"] = value
    save_game()
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index("music"), log(value/100)*20)

func _on_SFXSlider_value_changed(value):
    $SFXLabel/Value.text = str(value) + "%"
    save["sfx"] = value
    save_game()
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index("sfx"), log(value/100)*20)


func _on_MouseSlider_value_changed(value):
    $MouseLabel/Value.text = str(pow(value,2)/10000)
    save["mouse"] = value
    save_game()
    Global.sens = pow(value,2)/10000


func _on_FOVSlider_value_changed(value):
    $FOVLabel/Value.text = str(value)
    save["fov"] = value
    save_game()
    Global.fov = value


