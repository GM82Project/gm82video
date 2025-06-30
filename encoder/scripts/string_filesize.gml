if (argument0<1024) return string(argument0)+" bytes"
if (argument0<1024*1024) return string(argument0/1024)+" KB"
return string(argument0/1024/1024)+" MB"
