{ stdenv, fetchurl, zlib, boost, protobuf, ncurses, pkgconfig, IOTty
, makeWrapper, perl, openssl }:

stdenv.mkDerivation rec {
  name = "mosh-1.2.4";

  src = fetchurl {
    url = "http://mosh.mit.edu/${name}.tar.gz";
    sha256 = "0inzfmqrab3n97m7rrmhd4xh3hjz0xva2sfl5m06w11668r0skg7";
  };

  buildInputs = [ boost protobuf ncurses zlib pkgconfig IOTty makeWrapper perl openssl ];

  postInstall = ''
      wrapProgram $out/bin/mosh --prefix PERL5LIB : $PERL5LIB
  '';

  meta = {
    homepage = http://mosh.mit.edu/;
    description = "Remote terminal application that allows roaming, local echo, etc.";
    license = "GPLv3+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
