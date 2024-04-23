#define Create_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
spd=1
vid=noone
str=""

label=rmEncoder_15B7D571
#define Step_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
if (vid) label.str=str+string_format(video_get_length(vid)*video_get_progress(vid),4,2)+"/"+string(video_get_length(vid))+" - speed: "+string(spd)
else label.str="Encoding preview"
#define Keyboard_32
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
if (vid) if (!video_isplaying(vid)) video_reset(vid)
#define Mouse_60
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
if (vid) {
    spd=min(4,spd+0.25)
    video_set_speed(vid,spd)
}
#define Mouse_61
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
if (vid) {
    spd=max(0.25,spd-0.25)
    video_set_speed(vid,spd)
}
#define Draw_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
draw_self()

if (Encoder.encoding) {
    if (surface_exists(Encoder.render)) {
        w=surface_get_width(Encoder.render)
        h=surface_get_height(Encoder.render)
        scale=min(sprite_width/w,sprite_height/h)
        offx=(sprite_width-w*scale)/2
        offy=(sprite_height-h*scale)/2

        texture_set_interpolation(1)
        draw_surface_stretched(Encoder.render,x+offx,y+offy,w*scale,h*scale)
        texture_set_interpolation(0)
    }
} else if (vid) {
    w=video_get_width(vid)
    h=video_get_height(vid)

    scale=min(sprite_width/w,sprite_height/h)
    offx=(sprite_width-w*scale)/2
    offy=(sprite_height-h*scale)/2

    texture_set_interpolation(1)
    video_draw(vid,x+offx,y+offy,w*scale,h*scale)
    texture_set_interpolation(0)
}
#define KeyPress_27
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
if (vid) video_set_pause(vid,1)
#define KeyPress_32
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
if (vid) video_reset(vid)
