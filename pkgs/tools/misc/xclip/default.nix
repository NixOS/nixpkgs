{ stdenv, fetchurl, x11, libXmu }:

stdenv.mkDerivation {
  name = "xclip-0.11";

  src = fetchurl {
    url = "mirror://sourceforge/xclip/xclip-0.11.tar.gz";
    sha256 = "0ipwxkfqz66fz6jlln1v46sd2kr6bkqzq6j5hkzn6pb3grmzsacg";
  };

  buildInputs = [ x11 libXmu ];

  meta = { 
    description = "Tool to access the X clipboard from a console application";
    homepage = http://people.debian.org/~kims/xclip/;
    license = "GPL-2";
  };
}
