# Script reference

GameMaker 8 scripts that bundle several files into one `.dlrc` file and unpack them again. They only bundle, without compression. There is a 39DLL variant and a Faucet Networking variant, and the `.dlrc` files they make are not compatible with each other.

## Common

- `dlrc_init()` : Initializes the scripts. Must be called once before any other script is used. Returns the id of the `ds_list` that receives the list of extracted files. Even indexes hold file names and odd indexes hold file sizes.
- `dlrc_add(dlrc, count, file1, file2, ...)` : Bundles `count` files into the `dlrc` file. If the `dlrc` file already exists the files are appended, otherwise it is created. Returns the number of files in the `dlrc` file afterwards.
- `dlrc_extract(dlrc, folder, start, count)` : Extracts `count` files from the `dlrc` file into `folder`, beginning at the file numbered `start`. `start` counts from 0. If `start` is -1 every file is extracted and `count` can be omitted. `folder` ends with a backslash like `"extract\"`, or is `""` to extract next to the executable. The names and sizes of the extracted files go into the `ds_list` returned by `dlrc_init`. Returns `false` if the `dlrc` file does not exist.

## 39DLL variant only

- `dlrc_set_estring(password)` : Sets the password used to encrypt the body. `""` means no encryption. The same password must be used for bundling and extracting.
- `dlrc_get_fmax(dlrc)` : Returns the number of files in the `dlrc` file.

## Changes

v7.0

- A Faucet Networking variant was made with the same contents as the 39DLL variant. The Faucet Networking variant has no encryption and no `dlrc_get_fmax`.
