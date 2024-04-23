#define Create_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
grab=0
delta=10
#define Step_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
if (grab) delta=round(lerp(1,128,saturate((mouse_x-x)/sprite_width)))
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
delta=10
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
l=lerp2(1,128,0,sprite_width,delta)

draw_line(x+l,y,x+l,y+31)
draw_text(x,y,delta)
