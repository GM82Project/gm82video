#define Mouse_4
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
File.save_as=filename_change_ext(get_save_filename("RV2 Files|*.rv2",filename_change_ext(File.name,".rv2")),".rv2")
#define Draw_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
draw_self()
draw_text(x,y,"Save As")
