{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "e2fsprogs-1.41.3";
  
  src = fetchurl {
    url = mirror://sourceforge/e2fsprogs/e2fsprogs-1.41.3.tar.gz;
    sha256 = "0yldax5z1d1gfxpvzmr8y2z5zg5xhbi9pjjy4yw0q28dd2pfsxyf";
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

  meta = {
    homepage = http://e2fsprogs.sourceforge.net/;
    description = "Tools for creating and checking ext2/ext3/ext4 filesystems";
  };
}
