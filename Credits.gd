extends CanvasLayer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export (PackedScene) var Duck
var timer
var line

func _process(delta):
    for i in range(0, 3):
        var game_pressed = Input.is_joy_button_pressed(i, JOY_START)
        if timer > 1 and game_pressed:
            return_to_game() 
    
    timer += delta
    if timer > 1:
        timer-=1
        spawn_duck()
    
    $ScrollingCredits.offset.y += delta * -300

func return_to_game():
    get_tree().change_scene("res://Game.tscn")

func spawn_duck():
    var duck = Duck.instance()
    duck.set_name('duck')
    
    duck.position = Vector2(-500, -500)
    
    self.add_child(duck)
    duck.set_owner(self)

func _ready():
    timer = 0
    line = 0
    $ScrollingCredits.get_node('Label').align=Label.ALIGN_CENTER
    $ScrollingCredits.get_node('Label').text = """
    
    
    
    
    
    
    
    
    
    DUCKS
    
    
    
    
    
    Developers:
    
    Daniel Lister
    
    
    Cristian Poll
    
    
    Aiden Storey
    
    
    
    
    
    
    Art:
    
    Sophia Feesh
        
    
    
    
    
    Audio:
    
    Jake Butineau
        
    
    
    
    Created for TOJam 13
    Flirteen With Danger
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    Commits:


initial commit   -Daniel

more ignore   -Daniel

Godot stuff   -Daniel

ducks that follow you   -Daniel

ducks that follow you   -Daniel

add analog support   -Cristian

change resolution to 1080   -Cristian

Added game script   -Aiden

broken duck adding   -Daniel

add terrain   -Cristian

Added basic hud   -Aiden

pin joints   -Daniel

what   -Daniel

Updated hud   -Aiden

Added hud to scene   -Aiden

resolution   -Daniel

boarders   -Daniel

boarders   -Daniel

movement   -Daniel

fix main scene   -Daniel

inb4 merge conflicts   -Aiden

fixed   -Aiden

Added game loop   -Aiden

Fixed default active players   -Aiden

add scoring logic   -Cristian

Im not sure   -Daniel

Changed state to enum   -Aiden

Removed old state   -Aiden

Godot   -Aiden

Fixed game scene   -Aiden

tighter movement/graphics   -Daniel

music   -Daniel

rock and damping ducks   -Daniel

add scoring   -Cristian

boost   -Daniel

tighten up the waterfalls   -Cristian

add layers   -Cristian

boosting   -Daniel

Tightened up duck handling   -Aiden

godot stuff?   -Daniel

Added picking up ducks   -Aiden

Changed handling collision with duck   -Aiden

Tightened player colliding with own duck   -Aiden

add duck spawning   -Cristian

add duck waterfall spawning   -Cristian

add duck spawning arcs   -Cristian

Tightened duck stealing   -Aiden

Fixed that thing   -Aiden

masking   -Daniel

godot stuff   -Daniel

masking on ducks   -Daniel

remove starting ducks   -Daniel

fix duck spawn   -Daniel

Tightening   -Aiden

clean up mask   -Daniel

recursive collision mask   -Daniel

Added set player   -Aiden

Tightened player stealing   -Aiden

add bg assets   -Cristian

add sprites for ducks   -Cristian

Removed duck stealing and added basic linked list   -Aiden

add borders for new terrain   -Cristian

juice up duck spawning   -Cristian

improve player spawning   -Cristian

move hud   -Daniel

no duck spin   -Daniel

rocks   -Daniel

 Fixed linked list   -Aiden

linked list   -Daniel

add duck sprite   -Cristian

dsfljfhfa   -Cristian

Tightening   -Aiden

Removed linked list   -Aiden

add sprites for all players   -Cristian

Fixed timer   -Aiden

readd game   -Cristian

Added z-index updating   -Aiden

Fixed z-index for spawning   -Aiden

Changed scoring angle   -Aiden

basic collecting   -Daniel

fix missing following duck   -Daniel

add auto spawning of ducks   -Cristian

Added end of game stuff   -Aiden

Merging I guess   -Aiden

a   -Aiden

fix player sprites   -Cristian

following duck fix   -Daniel

Added better handling of postgame   -Aiden

Removed current use of game end   -Aiden

some duck collecting   -Daniel

touch your own duck   -Daniel

fix scoring terrain catching issue   -Cristian

hook up boost to xbox   -Cristian

delete commented code   -Cristian

add credits   -Cristian

add scoring   -Cristian

ducks can pass through eachother   -Daniel

Added splash animation and bottom rocks overlay   -Aiden

juice the font   -Cristian

Fixed constantly changing frames count   -Aiden

fix fonts   -Cristian

change movement   -Cristian

duck tails   -Daniel

fix respawn velocity   -Cristian

duck depth   -Daniel

fix animation direction   -Daniel

follow duck rotation   -Daniel

add credits   -Cristian

make esc quit   -Daniel

fix spawn jamming maybe   -Cristian

Tightened post_game   -Aiden

final duck rotation   -Daniel

fix collion shapes and z sorting   -Daniel

Tightened up the game loop   -Aiden

juicier credits   -Cristian

Tightened the tightening   -Aiden

add boost indicator   -Cristian

Updated game time   -Aiden

Loosened the font size   -Aiden

recolor boost hint   -Cristian

Added bob and fixed conflict   -Aiden

SFX   -Daniel

Added bob   -Aiden

add goat to credits   -Cristian

readd boost hint   -Cristian

go behind rocks again   -Daniel

fix spawn arcs   -Cristian

fix spawn again   -Cristian

add boost label AGAIN   -Cristian

Added text   -Aiden

tighten up the boost   -Cristian

redamp duckies   -Cristian

fix spawn finally I hope   -Cristian

perfectly playable   -Cristian

duckworthy   -Cristian

fin   -Duckman

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    55
    
    """    


func _on_Button_pressed():
    return_to_game()
