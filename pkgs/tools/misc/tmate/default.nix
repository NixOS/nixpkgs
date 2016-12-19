{ stdenv, fetchFromGitHub, autoconf, automake, libtool, pkgconfig, zlib, openssl, libevent, ncurses, cmake, ruby, libmsgpack, libssh }:

stdenv.mkDerivation rec {
  name = "tmate-${version}";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner  = "nviennot";
    repo   = "tmate";
    rev    = version;
    sha256 = "1w3a7na0yj1y0x24qckc7s2y9xfak5iv6vyqrd0iibn3b7dxarli";
  };

  buildInputs = [ autoconf automake pkgconfig libtool zlib openssl libevent ncurses cmake ruby libmsgpack libssh ];

  dontUseCmakeConfigure=true;

  preConfigure = "./autogen.sh";

  meta = {
    homepage = http://tmate.io/;
    description = "Instant Terminal Sharing";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ DamienCassou ];
  };
}
