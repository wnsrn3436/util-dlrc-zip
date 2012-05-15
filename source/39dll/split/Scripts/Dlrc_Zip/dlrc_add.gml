var temp_file, temp_fmax, temp_size, temp_size_max, temp_var, i;
temp_fmax=0
temp_size_max=0

if file_exists(argument0)
{
    temp_file=dll39_file_open(argument0, 0)
    
    dll39_file_read(temp_file, 4, global.dlrc_buffer_id_)
    temp_fmax=dll39_read_uint(global.dlrc_buffer_id_)
    
    dll39_buffer_clear(global.dlrc_buffer_id_)
    dll39_file_set_pos(temp_file, dll39_file_size(temp_file)-(temp_fmax*4))
    dll39_file_read(temp_file, temp_fmax*4, global.dlrc_buffer_id_)
    for(temp_size_max=0; temp_size_max!=temp_fmax; temp_size_max+=1){temp_size[temp_size_max]=dll39_read_uint(global.dlrc_buffer_id_)}
    
    dll39_file_set_pos(temp_file, 4)
    dll39_file_read(temp_file, dll39_file_size(temp_file)-(temp_fmax*4)-4, global.dlrc_buffer_id2_)
    if global.dlrc_estring_!=""{dll39_buffer_encrypt(global.dlrc_estring_, global.dlrc_buffer_id2_)}
    
    dll39_file_close(temp_file)
    file_delete(argument0)
}
dll39_buffer_clear(global.dlrc_buffer_id_)
dll39_write_uint(temp_fmax+argument1, global.dlrc_buffer_id_)

temp_var=argument1+2
for(i=2; i!=temp_var; i+=1)
{
    temp_file=dll39_file_open(argument[i], 0)
    temp_size[temp_size_max]=dll39_file_size(temp_file); temp_size_max+=1
    dll39_write_string(filename_name(argument[i]), global.dlrc_buffer_id2_)
    dll39_file_read(temp_file, dll39_file_size(temp_file), global.dlrc_buffer_id2_)
    dll39_file_close(temp_file)
}
if global.dlrc_estring_!=""{dll39_buffer_encrypt(global.dlrc_estring_, global.dlrc_buffer_id2_)}

temp_file=dll39_file_open(argument0, 1)
dll39_buffer_copy(global.dlrc_buffer_id_, global.dlrc_buffer_id2_)
for(i=0; i!=temp_size_max; i+=1){dll39_write_uint(temp_size[i], global.dlrc_buffer_id_)}
dll39_file_write(temp_file, global.dlrc_buffer_id_)
dll39_file_close(temp_file)

dll39_buffer_clear(global.dlrc_buffer_id_)
dll39_buffer_clear(global.dlrc_buffer_id2_)

return temp_fmax+argument1
