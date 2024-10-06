#define Create_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
name=""
#define Mouse_4
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
fn=get_open_filename("Any video file|*.mp4;*.mov;*.3gp;*.mkv;*.ogv;*.wmv;*.bik;*.mpg;*.mpeg;*.smk;*.m4v;*.avi;*.gif","")
if (fn!="") {
    name=fn
    with (Previewer) if (vid) {video_destroy(vid) vid=noone}
}
#define Draw_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
draw_self()
if (name="") draw_text(x,y,"No file loaded")
else draw_text(x,y,filename_name(name))
