if !file_exists(argument0){return 0}
ds_list_clear(global.dlrc_efile_)

var temp_fmax, temp_size, temp_size_max, temp_name, i;

append_file_to_buffer(global.dlrc_buffer_id_, argument0)
temp_fmax=read_uint(global.dlrc_buffer_id_)

buffer_set_readpos(global.dlrc_buffer_id_, buffer_size(global.dlrc_buffer_id_)-(temp_fmax*4))
for(temp_size_max=0; temp_size_max!=temp_fmax; temp_size_max+=1){temp_size[temp_size_max]=read_uint(global.dlrc_buffer_id_)}

buffer_set_readpos(global.dlrc_buffer_id_, 4)
if argument2=-1
{
    for(i=0; i!=temp_fmax; i+=1)
    {
        temp_name=read_string(global.dlrc_buffer_id_, read_uint(global.dlrc_buffer_id_))
        file_delete(argument1+temp_name)
        
        buffer_set_readpos(global.dlrc_buffer_id_, buffer_size(global.dlrc_buffer_id_)-buffer_bytes_left(global.dlrc_buffer_id_))
        write_buffer_part(global.dlrc_buffer_id2_, global.dlrc_buffer_id_, temp_size[i])
        write_buffer_to_file(global.dlrc_buffer_id2_, argument1+temp_name)
        
        ds_list_add(global.dlrc_efile_, temp_name)
        ds_list_add(global.dlrc_efile_, temp_size[i])
        buffer_clear(global.dlrc_buffer_id2_)
    }
}
else
{
    for(i=0; i!=argument2; i+=1){buffer_set_readpos(global.dlrc_buffer_id_, read_uint(global.dlrc_buffer_id_)+buffer_size(global.dlrc_buffer_id_)-buffer_bytes_left(global.dlrc_buffer_id_)+temp_size[i])}
    argument3=argument2+argument3
    for(i=argument2; i!=argument3; i+=1)
    {
        temp_name=read_string(global.dlrc_buffer_id_, read_uint(global.dlrc_buffer_id_))
        file_delete(argument1+temp_name)
        
        buffer_set_readpos(global.dlrc_buffer_id_, buffer_size(global.dlrc_buffer_id_)-buffer_bytes_left(global.dlrc_buffer_id_))
        write_buffer_part(global.dlrc_buffer_id2_, global.dlrc_buffer_id_, temp_size[i])
        write_buffer_to_file(global.dlrc_buffer_id2_, argument1+temp_name)
        
        ds_list_add(global.dlrc_efile_, temp_name)
        ds_list_add(global.dlrc_efile_, temp_size[i])
        buffer_clear(global.dlrc_buffer_id2_)
    }
}
buffer_clear(global.dlrc_buffer_id_)
