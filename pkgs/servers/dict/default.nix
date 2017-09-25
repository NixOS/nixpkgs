{ stdenv, fetchurl, which, bison, flex, libmaa, zlib, libtool }:

stdenv.mkDerivation rec {
  name = "dictd-${version}";
  version = "1.12.1";

  src = fetchurl {
    url = "mirror://sourceforge/dict/dictd-${version}.tar.gz";
    sha256 = "0min6v60b6z5mrymyjfwzx8nv6rdm8pd8phlwl6v2jl5vkngcdx2";
  };

  buildInputs = [ libmaa zlib ];

  nativeBuildInputs = [ bison flex libtool which ];

  enableParallelBuilding = true;

  patchPhase = "patch -p0 < ${./buildfix.diff}";
  configureFlags = [
    "--enable-dictorg"
    "--datadir=/run/current-system/share/dictd"
  ];

  meta = with stdenv.lib; {
    description = "Dict protocol server and client";
    homepage    = http://www.dict.org;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ mornfall ];
    platforms   = platforms.linux;
  };
}
