#define Step_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
y=Player.h-48
image_xscale=(Player.w-16-x)/32
#define Draw_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
draw_self()
if (Player.video) {
    p=video_get_progress(Player.video)
    u=round(p*sprite_width)
    draw_line(x+u,y,x+u,y+31)
    draw_set_valign(1)
    draw_text(x+4,y+16,format_time(p*video_get_length(Player.video)))
    draw_set_valign(0)
}
