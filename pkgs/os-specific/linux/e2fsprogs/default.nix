{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "e2fsprogs-1.40.8";
  src = fetchurl {
    url = mirror://sourceforge/e2fsprogs/e2fsprogs-1.40.8.tar.gz;
    sha256 = "1bgfi1b7zl60lbc8b0bcqv9rk886jcwwq091n08in4msnpw71prq";
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
