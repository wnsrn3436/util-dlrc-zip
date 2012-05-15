# DLRC Zip

An archive library for GameMaker 8. It is a set of scripts that bundles several files into one `.dlrc` file and unpacks them again, using a format designed for this library. It supports appending files to an existing archive, extracting only a chosen range, and encrypting the body. Despite the name Zip it does not compress anything, it only bundles. Two builds were released, one backed by 39DLL and one by Faucet Networking, depending on which extension does the file I/O.


## How to use

The Releases download contains the script resource (`.gmres`), the extension (`.gex`), and examples for each of the two builds. Install the extension you want to use in GameMaker 8, then load the resource through `File > Import Resources`.

```gml
list = dlrc_init()                          // once. Returns the ds_list that will hold extraction results
dlrc_set_estring("12345")                   // 39DLL build only. Leave empty for no encryption

dlrc_add("data.dlrc", 2, "target1.exe", "target2.txt")   // bundle two files. Appends if the archive already exists
dlrc_extract("data.dlrc", "extract\", -1)                // extract everything
dlrc_extract("data.dlrc", "extract\", 1, 1)              // extract one file starting at index 1
```

After `dlrc_extract` finishes, the list returned by `dlrc_init` holds the name and size of each extracted file, alternating. `dlrc_get_fmax` reads only the number of files in an archive. The arguments of every script are described in [docs/reference.md](docs/reference.md).


## How it works

**The format has three parts: count, body, size table.**

```
[file count 4 bytes] [name + content] [name + content] ... [size 4 bytes] [size 4 bytes] ...
```

The first 4 bytes are the file count, and the end holds one 4 byte size per file. Because the size table sits at the end, appending means adding the new files after the body and rewriting only the table. Partial extraction is just skipping the earlier files by their sizes.

```gml
// end of dlrc_add: put the body after the count, then write the size table
dll39_buffer_copy(global.dlrc_buffer_id_, global.dlrc_buffer_id2_)
for(i=0; i!=temp_size_max; i+=1){dll39_write_uint(temp_size[i], global.dlrc_buffer_id_)}
dll39_file_write(temp_file, global.dlrc_buffer_id_)
```

**Only the body is encrypted.** With a password set, the 39DLL build wraps the body, which holds the names and contents, with `dll39_buffer_encrypt`. The count and the size table stay in plain form, so how many files there are and how big each one is stays visible, but the names and contents cannot be read without the password. When appending, the existing body is decrypted, the new files are added, and it is wrapped again.

**The two builds store file names differently.** The 39DLL build writes a name as a null terminated string, while the Faucet Networking build writes a 4 byte length followed by the string. Archives made by one build are therefore not compatible with the other. The Faucet Networking build has no encryption and no `dlrc_get_fmax`.


## Files

| Path | Contents |
|---|---|
| `source/39dll/dlrc-zip-39dll.gmk` | Project file of the 39DLL build |
| `source/39dll/split/` | Text tree produced by GmkSplitter |
| `source/39dll/39dll_Ext.gex` | The 39DLL extension |
| `source/fn/dlrc-zip-fn.gmk` | Project file of the Faucet Networking build |
| `source/fn/split/` | Text tree produced by GmkSplitter |
| `source/fn/Faucet Networking v1.4.2.gex` | The Faucet Networking extension |
| `docs/reference.md` | Script reference |
| Releases | Script resources, extensions, and examples for both builds |


## Credits

39DLL is a widely used file and networking DLL for GameMaker, made by 39ster. Faucet Networking is a networking and buffer extension for GameMaker made by Medo42.


## License

zlib. See [LICENSE](LICENSE). Bundled libraries made by other people keep their own licenses.
