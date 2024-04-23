#define Create_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
w=-1
h=-1

room_speed=display_get_frequency()
set_application_title("Video Player")
draw_set_font(Font)
window_resize_buffer(room_width,room_height,1,0)

video=noone
mute=false
restart=false

file_drag_enable(1)

if (parameter_count()) {
    alarm[0]=2
}

window_set_size(640,512)
#define Alarm_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
fn=parameter_string(1)
if (filename_ext(fn)==".rv2") {
    video=video_play(fn)
    set_application_title(filename_name(fn))
    room_caption=filename_name(fn)+" - Game Maker 8.2 Video Player"
    window_set_size(max(640,video_get_width(video)),max(512,video_get_height(video)+64))
    restart=true
}
#define Alarm_1
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
window_set_visible(1)
#define Step_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
if (file_drag_count()) {
    fn=file_drag_name(0)
    if (filename_ext(fn)==".rv2") {
        if (video) video_destroy(video)
        video=video_play(fn)
        set_application_title(filename_name(fn))
        room_caption=filename_name(fn)+" - Game Maker 8.2 Video Player"
        if (video) {
            video_set_volume(video,!mute)
            window_set_size(max(640,video_get_width(video)),max(512,video_get_height(video)+64))
            restart=true
        }
        window_set_foreground()
    }
    file_drag_clear()
}

nw=window_get_width()
nh=window_get_height()

if (nw!=w)
or (nh!=h)
or (restart) {
    w=max(640,nw)
    h=max(512,nh)
    window_set_size(w,h)
    restart=false
    room_set_width(room,w)
    room_set_height(room,h)
    room_restart()
    alarm[1]=1
}
#define Mouse_53
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
if (video) if (mouse_y<h-64) {
    if (video_get_progress(video)==1) video_reset(video)
    else video_set_pause(video,video_isplaying(video))
}
#define Other_4
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
event_step()

if (video) room_caption=filename_name(fn)+" - Game Maker 8.2 Video Player"
#define Draw_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
d3d_set_viewport(0,0,w,h)
draw_clear(background_color)
draw_line(0,h-64,w,h-64)

if (video) {
    vw=video_get_width(video)
    vh=video_get_height(video)
    scale=min(w/vw,(h-64)/vh)
    offx=(w-vw*scale)/2
    offy=(h-64-vh*scale)/2
    texture_set_interpolation(1)
    draw_rect(0,0,w,h-64,0)
    video_draw(video,offx,offy,vw*scale,vh*scale)
    texture_set_interpolation(0)
    if (point_in_rectangle(mouse_x,mouse_y,0,0,w,h-64)) {
        str=filename_name(fn)+
            "#Size: "+string(video_get_size(video)/1024/1024)+" MB"+
            "#Dimensions: "+string(video_get_width(video))+"x"+string(video_get_height(video))+
            "#Frames: "+string(video_get_frames(video))+
            "#FPS: "+string(video_get_fps(video))+
            "#Duration: "+format_time(video_get_length(video))
        draw_set_color(0)
        draw_text(9,9,str)
        draw_set_color($ffff)
        draw_text(8,8,str)
        draw_set_color($ffffff)
    }
} else {
    d3d_set_viewport(0,0,w,h-64)
    draw_background_tiled_extra(background2_black,0,0,1,1,0,$ffffff,1,0,0)
    draw_background_stretched(background1,w div 2-64,(h-64) div 2-64,128,128)
    draw_set_halign(1)
    draw_text(w div 2,(h-64) div 2+56,"Game Maker 8.2 Video Player")
    draw_set_halign(0)
    d3d_set_viewport(0,0,w,h)
}
