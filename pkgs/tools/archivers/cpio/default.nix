{ stdenv, fetchurl, fetchpatch }:

let
  version = "2.12";
  name = "cpio-${version}";
in stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://gnu/cpio/${name}.tar.bz2";
    sha256 = "0vi9q475h1rki53100zml75vxsykzyhrn70hidy41s5c2rc8r6bh";
  };

  patches = [ ./CVE-2015-1197-cpio-2.12.patch ];

  preConfigure = if stdenv.isCygwin then ''
    sed -i gnu/fpending.h -e 's,include <stdio_ext.h>,,'
  '' else null;

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.gnu.org/software/cpio/;
    description = "A program to create or extract from cpio archives";
    platforms = stdenv.lib.platforms.all;
    priority = 6; # resolves collision with gnutar's "libexec/rmt"
  };
}
