var temp_fmax, temp_size, temp_size_max, temp_var, i;
temp_fmax=0
temp_size_max=0

if file_exists(argument0)
{
    append_file_to_buffer(global.dlrc_buffer_id_, argument0)
    temp_fmax=read_uint(global.dlrc_buffer_id_)
    
    buffer_set_readpos(global.dlrc_buffer_id_, buffer_size(global.dlrc_buffer_id_)-(temp_fmax*4))
    for(temp_size_max=0; temp_size_max!=temp_fmax; temp_size_max+=1){temp_size[temp_size_max]=read_uint(global.dlrc_buffer_id_)}
    
    buffer_set_readpos(global.dlrc_buffer_id_, 4)
    write_buffer_part(global.dlrc_buffer_id2_, global.dlrc_buffer_id_, buffer_bytes_left(global.dlrc_buffer_id_)-(temp_fmax*4))
    
    file_delete(argument0)
    buffer_clear(global.dlrc_buffer_id_)
}
write_uint(global.dlrc_buffer_id_, temp_fmax+argument1)

temp_var=argument1+2
for(i=2; i!=temp_var; i+=1)
{
    write_uint(global.dlrc_buffer_id2_, string_length(filename_name(argument[i])))
    write_string(global.dlrc_buffer_id2_, filename_name(argument[i]))
    buffer_set_readpos(global.dlrc_buffer_id2_, buffer_size(global.dlrc_buffer_id2_))
    append_file_to_buffer(global.dlrc_buffer_id2_, argument[i])
    temp_size[temp_size_max]=buffer_bytes_left(global.dlrc_buffer_id2_)
    temp_size_max+=1
}
write_buffer(global.dlrc_buffer_id_, global.dlrc_buffer_id2_)
for(i=0; i!=temp_size_max; i+=1){write_uint(global.dlrc_buffer_id_, temp_size[i])}
write_buffer_to_file(global.dlrc_buffer_id_, argument0)

buffer_clear(global.dlrc_buffer_id_)
buffer_clear(global.dlrc_buffer_id2_)

return temp_fmax+argument1
