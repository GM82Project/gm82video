fn=filename_change_ext(filename_name(parameter_string(0)),"")+".ini"

ini_open(fn)
ini_write_string("encoder","ffmpeg",global.ffmpeg)
ini_write_real("encoder","scale",Scaling.scaling)
ini_write_real("encoder","bitrate",Abitrate.bitrate)
ini_write_real("encoder","delta",Delta.delta)
ini_write_real("encoder","keyframe",Keyframe.keyframe)
ini_close()
