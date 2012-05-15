/**************************************************************************

Dlrc Zip v7.0 (FN var.)

Maker --- wnsrn3436@naver.com

**************************************************************************/

if variable_global_exists("dlrc_buffer_id_"){return 0}

global.dlrc_buffer_id_=buffer_create()
global.dlrc_buffer_id2_=buffer_create()

global.dlrc_efile_=ds_list_create()

return global.dlrc_efile_
