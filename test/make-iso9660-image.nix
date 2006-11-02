{ stdenv, cdrtools

  # The file name of the resulting ISO image.
, isoName ? "cd.iso"

, # The files and directories to be placed in the ISO file system.
  # This is a list of attribute sets {source, target} where `source'
  # is the file system object (regular file or directory) to be
  # grafted in the file system at path `target'.
  contents

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
  inherit isoName bootable bootImage;
  graftList = map ({source, target}: target + "=" + source) contents;
}
