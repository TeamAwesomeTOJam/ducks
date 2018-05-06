extends CanvasLayer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var timer
var line

func _process(delta):
    for i in range(0, 3):
        var game_pressed = Input.is_joy_button_pressed(i, JOY_START)
        if timer > 1 and game_pressed:
            return_to_game() 
    
    timer += delta
    
    $ScrollingCredits.offset.y += delta * -300

func return_to_game():
    get_tree().change_scene("res://Game.tscn")

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
        
    
    
    
    
    
    
    
    Commits:

delete commented code     -cpoll

hook up boost to xbox     -cpoll

fix scoring terrain catching issue     -cpoll

touch your own duck     -Daniel Lister

Merge branch 'master' of github.com:TeamAwesomeTOJam/ducks     -Daniel Lister

some duck collecting     -Daniel Lister

Merge branch 'master' of github.com:TeamAwesomeTOJam/ducks     -Aiden Storey

Removed current use of game end     -Aiden Storey

Added better handling of postgame     -Aiden Storey

Merge branch 'master' of github.com:TeamAwesomeTOJam/ducks     -Daniel Lister

following duck fix     -Daniel Lister

fix player sprites     -cpoll

a     -Aiden Storey

Merge branch 'master' of github.com:TeamAwesomeTOJam/ducks     -Aiden Storey

Merging I guess     -Aiden Storey

Added end of game stuff     -Aiden Storey

Merge branch 'master' of github.com:TeamAwesomeTOJam/ducks     -cpoll

add auto spawning of ducks     -cpoll

fix missing following duck     -Daniel Lister

merge     -Daniel Lister

basic collecting     -Daniel Lister

Changed scoring angle     -Aiden Storey

Fixed z-index for spawning     -Aiden Storey

Added z-index updating     -Aiden Storey

readd game     -cpoll

Merge branch 'master' of github.com:TeamAwesomeTOJam/ducks     -cpoll

Fixed timer     -Aiden Storey

add sprites for all players     -cpoll

Removed linked list     -Aiden Storey

Merge branch 'master' of github.com:TeamAwesomeTOJam/ducks     -Aiden Storey

Tightening     -Aiden Storey

dsfljfhfa     -cpoll

Merge branch 'master' of github.com:TeamAwesomeTOJam/ducks     -cpoll

add duck sprite     -cpoll

linked list     -Daniel Lister

Merge branch 'master' of github.com:TeamAwesomeTOJam/ducks     -Aiden Storey

 Fixed linked list     -Aiden Storey

rocks     -Daniel Lister

no duck spin     -Daniel Lister

Merge branch 'master' of github.com:TeamAwesomeTOJam/ducks     -Daniel Lister

move hud     -Daniel Lister

improve player spawning     -cpoll

juice up duck spawning     -cpoll

add borders for new terrain     -cpoll

Merge branch 'master' of github.com:TeamAwesomeTOJam/ducks     -Aiden Storey

Removed duck stealing and added basic linked list     -Aiden Storey

add sprites for ducks     -cpoll

add bg assets     -cpoll

Tightened player stealing     -Aiden Storey

Merge branch 'master' of github.com:TeamAwesomeTOJam/ducks     -Aiden Storey

Added set player     -Aiden Storey

recursive collision mask     -Daniel Lister

Merge branch 'master' of github.com:TeamAwesomeTOJam/ducks     -Daniel Lister

Merge branch 'master' of github.com:TeamAwesomeTOJam/ducks     -Aiden Storey

clean up mask     -Daniel Lister

Tightening     -Aiden Storey

fix duck spawn     -Daniel Lister

remove starting ducks     -Daniel Lister

masking on ducks     -Daniel Lister

godot stuff     -Daniel Lister

masking     -Daniel Lister

Fixed that thing     -Aiden Storey

Merge branch 'master' of github.com:TeamAwesomeTOJam/ducks     -Aiden Storey

Tightened duck stealing     -Aiden Storey

add duck spawning arcs     -cpoll

add duck waterfall spawning     -cpoll

add duck spawning     -cpoll

Tightened player colliding with own duck     -Aiden Storey

Changed handling collision with duck     -Aiden Storey

Added picking up ducks     -Aiden Storey

Merge branch 'master' of github.com:TeamAwesomeTOJam/ducks     -Aiden Storey

Merge branch 'master' of github.com:TeamAwesomeTOJam/ducks     -Aiden Storey

godot stuff?     -Daniel Lister

Tightened up duck handling     -Aiden Storey

boosting     -Daniel Lister

add layers     -cpoll

tighten up the waterfalls     -cpoll

boost     -Daniel Lister

add scoring     -cpoll

rock and damping ducks     -Daniel Lister

music     -Daniel Lister

tighter movement/graphics     -Daniel Lister

Fixed game scene     -Aiden Storey

Godot     -Aiden Storey

Removed old state     -Aiden Storey

Merge branch 'master' of github.com:TeamAwesomeTOJam/ducks     -Aiden Storey

Changed state to enum     -Aiden Storey

Im not sure     -Daniel Lister

merge     -Daniel Lister

add scoring logic     -cpoll

Fixed default active players     -Aiden Storey

Added game loop     -Aiden Storey

fixed     -Aiden Storey

Merge branch 'master' of github.com:TeamAwesomeTOJam/ducks     -Aiden Storey

inb4 merge conflicts     -Aiden Storey

fix main scene     -Daniel Lister

movement     -Daniel Lister

boarders     -Daniel Lister

boarders     -Daniel Lister

resolution     -Daniel Lister

Merge branch 'master' of github.com:TeamAwesomeTOJam/ducks     -Aiden Storey

Added hud to scene     -Aiden Storey

Updated hud     -Aiden Storey

what     -Daniel Lister

pin joints     -Daniel Lister

Added basic hud     -Aiden Storey

add terrain     -cpoll

broken duck adding     -Daniel Lister

Added game script     -Aiden Storey

change resolution to 1080     -cpoll

add analog support     -cpoll

ducks that follow you     -Daniel Lister

ducks that follow you     -Daniel Lister

Godot stuff     -Daniel Lister

more ignore     -Daniel Lister

initial commit     -Daniel Lister
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    55
    
    """    


func _on_Button_pressed():
    return_to_game()
