#define Create_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
vfps=30
#define Mouse_4
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
vfps=max(1,min(Encoder.videofps,real(get_string("Video FPS: (source is "+string(Encoder.videofps)+")",string(vfps)))))
#define Mouse_5
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
vfps=Encoder.videofps
#define Draw_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
draw_self()
draw_text(x,y,string(vfps)+"/"+string(Encoder.videofps))
