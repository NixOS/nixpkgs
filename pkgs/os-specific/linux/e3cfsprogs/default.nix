{stdenv, fetchurl, gettext}:

stdenv.mkDerivation {
  name = "e3cfsprogs-1.39";
  builder = ./builder.sh;

  patches = [ ./e3cfsprogs-1.39_bin_links.patch ./e3cfsprogs-1.39_etc.patch ];

  src = fetchurl {
    url = http://ext3cow.com/e3cfsprogs/e3cfsprogs-1.39.tgz;
    sha256 = "8dd3de546aeb1ae42fb05409aeb724a145fe9aa1dbe1115441c2297c9d48cf31";
  };

  configureFlags =
    if stdenv ? isDietLibC
    then ""
    else "--enable-dynamic-e2fsck --enable-elf-shlibs";
  buildInputs = [gettext];
  preInstall = "installFlagsArray=('LN=ln -s')";
  postInstall = "make install-libs";

  NIX_CFLAGS_COMPILE =
    if stdenv ? isDietLibC then
      "-UHAVE_SYS_PRCTL_H " +
      (if stdenv.system == "x86_64-linux" then "-DHAVE_LSEEK64_PROTOTYPE=1 -Dstat64=stat" else "")
    else "";
}


#note that ext3cow requires the ext3cow kernel patch !!!!
