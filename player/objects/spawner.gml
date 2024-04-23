#define Step_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
room_caption="Game Maker 8.2 Video - FPS: "+string(fps_fast)+" TPS: "+string(fps_real)

var fn;

if (file_drag_count()) {
    fn=file_drag_name(0)
    if (filename_ext(fn)==".rv2") {
        with (instance_create(mouse_x,mouse_y,videoctrl)) {
            video=video_play(fn)
            str=filename_name(fn)+"#"+string(video_get_width(video))+"x"+string(video_get_height(video))+" - fps: "+string(video_get_fps(video))+" - "
        }
    }
    file_drag_clear()
}
#define Other_4
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
room_speed=display_get_frequency()

file_drag_enable(1)
