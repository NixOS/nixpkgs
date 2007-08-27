{stdenv, fetchurl, gettext}:

stdenv.mkDerivation {
  name = "e2fsprogs-1.39";
  src = fetchurl {
    url = mirror://sourceforge/e2fsprogs/e2fsprogs-1.39.tar.gz;
    md5 = "06f7806782e357797fad1d34b7ced0c6";
  };
  configureFlags =
    if stdenv ? isDietLibC
    then ""
    else "--enable-dynamic-e2fsck --enable-elf-shlibs";
  buildInputs = [gettext];
  patches = [./e2fsprogs-1.39_etc.patch];
  preInstall = "installFlagsArray=('LN=ln -s')";
  postInstall = "make install-libs";
  NIX_CFLAGS_COMPILE =
    if stdenv ? isDietLibC then
      "-UHAVE_SYS_PRCTL_H " +
      (if stdenv.system == "x86_64-linux" then "-DHAVE_LSEEK64_PROTOTYPE=1 -Dstat64=stat" else "")
    else "";
}
