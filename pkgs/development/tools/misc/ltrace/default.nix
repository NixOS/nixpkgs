{ stdenv, fetchurl, elfutils, libunwind }:

stdenv.mkDerivation {
  name = "ltrace-0.7.3";

  src = fetchurl {
    url = mirror://debian/pool/main/l/ltrace/ltrace_0.7.3.orig.tar.bz2;
    sha256 = "00wmbdghqbz6x95m1mcdd3wd46l6hgcr4wggdp049dbifh3qqvqf";
  };

  buildInputs = [ elfutils libunwind ];

  prePatch = let
      debian = fetchurl {
        url = mirror://debian/pool/main/l/ltrace/ltrace_0.7.3-6.debian.tar.xz;
        sha256 = "0xc4pfd8qw53crvdxr29iwl8na53zmknca082kziwpvlzsick4kp";
      };
    in ''
      tar xf '${debian}'
      patches="$patches $(cat debian/patches/series | sed 's|^|debian/patches/|')"
    '';

  meta = with stdenv.lib; {
    description = "Library call tracer";
    homepage = https://www.ltrace.org/;
    platforms = [ "i686-linux" "x86_64-linux" ];
    license = licenses.gpl2;
  };
}
