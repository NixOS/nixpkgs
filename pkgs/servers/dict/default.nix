{ stdenv, fetchurl, which, bison, flex, libmaa, zlib, libtool }:

stdenv.mkDerivation rec {
  version = "1.12.1";
  name = "dictd-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/dict/dictd-${version}.tar.gz";
    sha256 = "0min6v60b6z5mrymyjfwzx8nv6rdm8pd8phlwl6v2jl5vkngcdx2";
  };

  buildInputs = [ flex bison which libmaa zlib libtool ];

  patchPhase = "patch -p0 < ${./buildfix.diff}";
  configureFlags = "--datadir=/var/run/current-system/share/dictd";

  meta = with stdenv.lib; {
    description = "Dict protocol server and client";
    maintainers = [ maintainers.mornfall ];
    platforms = platforms.linux;
  };
}
