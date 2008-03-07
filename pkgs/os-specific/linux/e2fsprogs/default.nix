{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "e2fsprogs-1.40.7";
  src = fetchurl {
    url = mirror://sourceforge/e2fsprogs/e2fsprogs-1.40.7.tar.gz;
    sha256 = "019czxrdz7f2nlcx4n9rb4cmjia7n038lhgnpamqdclxf0imfxjr";
  };
  configureFlags =
    if stdenv ? isDietLibC
    then ""
    else "--enable-elf-shlibs";
  preInstall = "installFlagsArray=('LN=ln -s')";
  postInstall = "make install-libs";
  NIX_CFLAGS_COMPILE =
    if stdenv ? isDietLibC then
      "-UHAVE_SYS_PRCTL_H " +
      (if stdenv.system == "x86_64-linux" then "-DHAVE_LSEEK64_PROTOTYPE=1 -Dstat64=stat" else "")
    else "";
}
