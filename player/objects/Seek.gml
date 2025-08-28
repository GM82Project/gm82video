#define Create_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
down=0
#define Step_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
y=Player.h-48
image_xscale=(Player.w-16-x)/32

//if (down) with (Player) video_seek(fgsfdfh)
#define Mouse_4
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
down=1

if (Player.video)
    video_set_pause(Player.video,true)
#define Mouse_56
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
if (down) {
    if (Player.video)
        video_set_pause(Player.video,false)
}

down=0
#define Draw_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
draw_button_ext(x,y,sprite_width,32,0,global.col_main)
if (Player.video) {
    p=video_get_progress(Player.video)
    u=round(p*(sprite_width-16))

    draw_set_valign(1)
    draw_text(x+4,y+16,format_time(p*video_get_length(Player.video)))
    draw_set_valign(0)
} else {
    u=0
}

draw_button_ext(x+u,y,16,32,!down,global.col_main)
