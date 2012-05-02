{ stdenv, fetchurl, zlib, boost, protobuf, ncurses, pkgconfig, IOTty
, makeWrapper, perl }:

stdenv.mkDerivation rec {
  name = "mosh-1.1.3";

  src = fetchurl {
    url = "https://github.com/downloads/keithw/mosh/${name}.tar.gz";
    sha256 = "1vkf7h8mcmfn9dgcwrww05mdijrl7321xv9wlhf7j99nwmklc8sk";
  };

  buildInputs = [ boost protobuf ncurses zlib pkgconfig IOTty makeWrapper perl ];

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
