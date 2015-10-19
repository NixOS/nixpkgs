{ stdenv, fetchFromGitHub, autoconf, automake110x, libtool, pkgconfig, zlib, libssl, libevent, ncurses, cmake, ruby }:

stdenv.mkDerivation rec {
  name = "tmate-${version}";
  version = "1.8.10";

  src = fetchFromGitHub {
    owner  = "nviennot";
    repo   = "tmate";
    rev    = version;
    sha256 = "1bd9mi8fx40608zlady9dbv21kbdwc3kqrgz012m529f6cbysmzc";
  };

  buildInputs = [ autoconf automake110x pkgconfig libtool zlib libssl libevent ncurses cmake ruby ];

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
