{ stdenv, cdrtools

  # The file name of the resulting ISO image.
, isoName ? "cd.iso"

, # The files and directories to be placed in the ISO file system.
  # This is a list of attribute sets {source, target} where `source'
  # is the file system object (regular file or directory) to be
  # grafted in the file system at path `target'.
  contents

, # In addition to `contents', the closure of the store paths listed
  # in `packages' are also placed in the file system.
  packages ? []

, # `init' should be a store path, the closure of which is added to
  # the image, just like `packages'.  However, in addition, a symlink
  # `/init' to `init' will be created.
  init ? null

  # Whether this should be an El-Torito bootable CD.
, bootable ? false

  # The path (in the ISO file system) of the boot image.
, bootImage ? ""

}:

assert bootable -> bootImage != "";

stdenv.mkDerivation {
  name = "iso9660-image";
  builder = ./make-iso9660-image.sh;
  buildInputs = [cdrtools];
  inherit isoName packages init bootable bootImage;
  sources = map ({source, target}: source) contents;
  targets = map ({source, target}: target) contents;
}
