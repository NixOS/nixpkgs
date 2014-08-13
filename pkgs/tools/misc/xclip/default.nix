{ stdenv, fetchurl, x11, libXmu }:

stdenv.mkDerivation rec {
  name = "xclip-0.12";

  src = fetchurl {
    url = "mirror://sourceforge/xclip/${name}.tar.gz";
    sha256 = "0ibcf46rldnv0r424qcnai1fa5iq3lm5q5rdd7snsi5sb78gmixp";
  };

  buildInputs = [ x11 libXmu ];

  meta = { 
    description = "Tool to access the X clipboard from a console application";
    homepage = http://sourceforge.net/projects/xclip/;
    license = stdenv.lib.licenses.gpl2;
  };
}
