{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "minicom-2.3";
  
  src = fetchurl {
    url = "http://alioth.debian.org/frs/download.php/2332/${name}.tar.gz";
    sha256 = "1ysn0crdhvwyvdlbw0ms5nq06xy2pd2glwjs53p384byl3ac7jra";
  };

  buildInputs = [ncurses];
  
  configureFlags = [ "--sysconfdir=/etc" ];

  meta = {
    description = "Serial console";
  };
}
