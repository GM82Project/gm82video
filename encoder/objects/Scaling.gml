#define Create_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
grab=0
scaling=1
#define Step_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
if (grab) scaling=clamp(roundto((mouse_x-x)/sprite_width*100,5),5,100)/100
#define Mouse_4
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
grab=1
#define Mouse_5
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
scaling=1
#define Mouse_56
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
grab=0
#define Draw_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
draw_self()
l=scaling*sprite_width
draw_line(x+l,y,x+l,y+31)
draw_text(x,y,string(round(scaling*100))+"%")
