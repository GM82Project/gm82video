///format_time(seconds):timestr
//second -> hh:mm:ss.ms
var second,minute,hour,str;

millis=round(frac(argument0)*100)
second=floor(argument0)
minute=(second div 60)

str=string_pad(minute div 60,2)+":"+string_pad(minute mod 60,2)+":"+string_pad(second mod 60,2)+"."+string(millis)

return str
