{stdenv, fetchurl, gettext}:

stdenv.mkDerivation {
  name = "e2fsprogs-1.39";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/e2fsprogs-1.39.tar.gz;
    md5 = "06f7806782e357797fad1d34b7ced0c6";
  };
  configureFlags =
    if stdenv ? isDietLibC
    then ""
    else "--enable-dynamic-e2fsck --enable-elf-shlibs";
  buildInputs = [gettext];
  patches = [./e2fsprogs-1.39_etc.patch];
  preInstall = "installFlagsArray=('LN=ln -s')";
  NIX_CFLAGS_COMPILE =
    if stdenv ? isDietLibC then "-UHAVE_SYS_PRCTL_H" else "";
}
