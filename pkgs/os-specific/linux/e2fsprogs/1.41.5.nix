{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "e2fsprogs-1.41.5";
  
  src = fetchurl {
    url = "mirror://sourceforge/e2fsprogs/${name}.tar.gz";
    sha256 = "1611lcfp5vcng7g9sacyxhg1dklxpn2p5m43mvfl0dwa0phx1mxk";
  };
  
  configureFlags =
    if stdenv ? isDietLibC
    then "--with-diet-libc"
    else "--enable-elf-shlibs";

  preBuild = if stdenv ? isDietLibC then ''
    sed -e 's/-lpthread//' -i Makefile */Makefile */*/Makefile
  '' else "";
    
  preInstall = "installFlagsArray=('LN=ln -s')";
  
  postInstall = "make install-libs";
  
  NIX_CFLAGS_COMPILE =
    if stdenv ? isDietLibC then
      "-UHAVE_SYS_PRCTL_H " +
      (if stdenv.system == "x86_64-linux" then "-DHAVE_LSEEK64_PROTOTYPE=1 -Dstat64=stat" else "")
      + " -lcompat -lpthread "
    else "";

  meta = {
    homepage = http://e2fsprogs.sourceforge.net/;
    description = "Tools for creating and checking ext2/ext3/ext4 filesystems";
  };
}
