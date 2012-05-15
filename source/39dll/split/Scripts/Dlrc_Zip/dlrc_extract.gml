if !file_exists(argument0){return 0}

var temp_file, temp_file2, temp_fmax, temp_size, temp_size_max, temp_name, i;
ds_list_clear(global.dlrc_efile_)

temp_file=dll39_file_open(argument0, 0)
dll39_file_read(temp_file, 4, global.dlrc_buffer_id_)
temp_fmax=dll39_read_uint(global.dlrc_buffer_id_)

dll39_buffer_clear(global.dlrc_buffer_id_)
dll39_file_set_pos(temp_file, dll39_file_size(temp_file)-(temp_fmax*4))
dll39_file_read(temp_file, temp_fmax*4, global.dlrc_buffer_id_)
for(temp_size_max=0; temp_size_max!=temp_fmax; temp_size_max+=1){temp_size[temp_size_max]=dll39_read_uint(global.dlrc_buffer_id_)}

dll39_buffer_clear(global.dlrc_buffer_id_)
dll39_file_set_pos(temp_file, 4)
dll39_file_read(temp_file, dll39_file_size(temp_file)-(temp_fmax*4)-4, global.dlrc_buffer_id_)
if global.dlrc_estring_!=""{dll39_buffer_encrypt(global.dlrc_estring_, global.dlrc_buffer_id_)}

if argument2=-1
{
    for(i=0; i!=temp_fmax; i+=1)
    {
        temp_name=dll39_read_string(global.dlrc_buffer_id_)
        file_delete(argument1+temp_name)
        
        dll39_buffer_copy2(global.dlrc_buffer_id2_, dll39_get_pos(1, global.dlrc_buffer_id_), temp_size[i], global.dlrc_buffer_id_)
        dll39_set_pos(dll39_get_pos(1, global.dlrc_buffer_id_)+temp_size[i], global.dlrc_buffer_id_)
        
        temp_file2=dll39_file_open(argument1+temp_name, 1)
        dll39_file_write(temp_file2, global.dlrc_buffer_id2_)
        dll39_file_close(temp_file2)
        
        ds_list_add(global.dlrc_efile_, temp_name)
        ds_list_add(global.dlrc_efile_, temp_size[i])
        dll39_buffer_clear(global.dlrc_buffer_id2_)
    }
}
else
{
    for(i=0; i!=argument2; i+=1)
    {
        temp_name=dll39_read_string(global.dlrc_buffer_id_)
        dll39_set_pos(dll39_get_pos(1, global.dlrc_buffer_id_)+temp_size[i], global.dlrc_buffer_id_)
    }
    argument3=argument2+argument3
    for(i=argument2; i!=argument3; i+=1)
    {
        temp_name=dll39_read_string(global.dlrc_buffer_id_)
        file_delete(argument1+temp_name)
        
        dll39_buffer_copy2(global.dlrc_buffer_id2_, dll39_get_pos(1, global.dlrc_buffer_id_), temp_size[i], global.dlrc_buffer_id_)
        dll39_set_pos(dll39_get_pos(1, global.dlrc_buffer_id_)+temp_size[i], global.dlrc_buffer_id_)
        
        temp_file2=dll39_file_open(argument1+temp_name, 1)
        dll39_file_write(temp_file2, global.dlrc_buffer_id2_)
        dll39_file_close(temp_file2)
        
        ds_list_add(global.dlrc_efile_, temp_name)
        ds_list_add(global.dlrc_efile_, temp_size[i])
        dll39_buffer_clear(global.dlrc_buffer_id2_)
    }
}
dll39_file_close(temp_file)
dll39_buffer_clear(global.dlrc_buffer_id_)

return global.dlrc_efile_
