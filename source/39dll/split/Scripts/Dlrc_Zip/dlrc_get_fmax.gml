var temp_file, temp_fmax;

temp_file=dll39_file_open(argument0, 0)
dll39_file_read(temp_file, 4, global.dlrc_buffer_id_)
temp_fmax=dll39_read_uint(global.dlrc_buffer_id_)
dll39_file_close(temp_file)

dll39_buffer_clear(global.dlrc_buffer_id_)

return temp_fmax
