#define Create_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
name=""
save_as=""
#define Mouse_4
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
load_video_file(get_open_filename("Anything|*.*",""))
#define Draw_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
draw_self()
if (name="") draw_text(x,y,"No file loaded")
else draw_text(x,y,filename_name(name))
