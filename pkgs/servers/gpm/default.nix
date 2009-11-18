{ stdenv, fetchurl, lzma, flex, bison, ncurses }:

stdenv.mkDerivation rec {
  name = "gpm-1.20.6";
  
  src = fetchurl {
    url = "http://linux.schottelius.org/gpm/archives/${name}.tar.lzma";
    sha256 = "13w61bh9nyjaa0n5a7qq1rvbqxjbxpqz5qmdmqqpqgrd2jlviar7";
  };

  buildInputs = [lzma flex bison ncurses];

  preConfigure =
    ''
      sed -e 's/[$](MKDIR)/mkdir -p /' -i doc/Makefile.in
    '';
      
  meta = {
    description = "Mouse daemon";
  };
}
