{ stdenv, fetchurl }:

let
  version = "2.13";
  name = "cpio-${version}";
in stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://gnu/cpio/${name}.tar.bz2";
    sha256 = "0vbgnhkawdllgnkdn6zn1f56fczwk0518krakz2qbwhxmv2vvdga";
  };

  preConfigure = if stdenv.isCygwin then ''
    sed -i gnu/fpending.h -e 's,include <stdio_ext.h>,,'
  '' else null;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://www.gnu.org/software/cpio/;
    description = "A program to create or extract from cpio archives";
    license = licenses.gpl3;
    platforms = platforms.all;
    priority = 6; # resolves collision with gnutar's "libexec/rmt"
  };
}
