#define Create_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
draw_set_font(Font)
global.encodeshader=sh_delta()

file_drag_enable(1)
if (file_find_first("*.gm82",0)!="") set_working_directory(directory_previous(working_directory))
file_find_close()

room_speed=display_get_frequency()

output=""
encoding=false
encoded=false
#define Step_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
if (file_drag_count()) {
    fn=file_drag_name(0)

    File.name=fn
    with (Previewer) if (vid) {video_destroy(vid) vid=noone}

    file_drag_clear()
}
#define Other_2
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
load_ini()

set_application_title("Video Encoder")
#define Other_3
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
save_ini()
#define Other_30
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=332
invert=0
*/
