{stdenv, fetchurl, gettext}:

stdenv.mkDerivation {
  name = "e3cfsprogs-1.39";
  builder = ./builder.sh;

  patches = [ ./e3cfsprogs-1.39_bin_links.patch ./e3cfsprogs-1.39_etc.patch ];

  src = fetchurl {
    url = http://www.ext3cow.com/Download_files/e3cfsprogs-1.39.tgz;
    sha256 = "26f535007a497d91c85d337ac67d62d42e3c8fde2ee02c5cb6b6e3e884a5d58f";
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
