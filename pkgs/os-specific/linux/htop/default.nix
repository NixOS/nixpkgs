{fetchurl, stdenv, ncurses}:

stdenv.mkDerivation rec {
  name = "htop-0.8.1";
  src = fetchurl {
    url = "mirror://sourceforge/htop/${name}.tar.gz";
    sha256 = "0a2x28ibz7bg18nnb75gdssxwys0xvzd760j1vnq5dx45wh2ibi5";
  };
  buildInputs = [ncurses];
  meta = {
    description = "An interactive process viewer for Linux";
    homepage = "http://htop.sourceforge.net";
  };
}
