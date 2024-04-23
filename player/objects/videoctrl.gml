#define Step_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
if (!instance_exists(video)) instance_destroy()
#define Draw_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
video_draw(video,x,y)
draw_set_valign(2)
draw_set_color(0)
draw_text(x,y-4,str+"progress: "+string(video_get_length(video)*video_get_progress(video))+"/"+string(video_get_length(video)))
