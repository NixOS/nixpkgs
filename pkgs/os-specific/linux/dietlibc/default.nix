{stdenv, fetchurl}:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "dietlibc-0.30";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/dietlibc-0.30.tar.bz2;
    md5 = "2465d652fff6f1fad3da3b98e60e83c9";
  };
  builder = ./builder.sh;
  inherit (stdenv) glibc;

  patches = [

    # dietlibc's sigcontext.h provides a macro called PC(), which is
    # rather intrusive (e.g., binutils fails to compile because of
    # it).  Rename it.
    ./pc.patch

    # wchar.h declares lots of functions that don't actually exist.
    # Remove them.
    ./no-wchar.h

  ];
}
