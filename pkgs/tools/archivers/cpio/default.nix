{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "cpio";
  version = "2.14";

  src = fetchurl {
    url = "mirror://gnu/cpio/cpio-${version}.tar.bz2";
    sha256 = "/NwV1g9yZ6b8fvzWudt7bIlmxPL7u5ZMJNQTNv0/LBI=";
  };

  separateDebugInfo = true;

  preConfigure = lib.optionalString stdenv.isCygwin ''
    sed -i gnu/fpending.h -e 's,include <stdio_ext.h>,,'
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://www.gnu.org/software/cpio/";
    description = "A program to create or extract from cpio archives";
    license = licenses.gpl3;
    platforms = platforms.all;
    priority = 6; # resolves collision with gnutar's "libexec/rmt"
  };
}
