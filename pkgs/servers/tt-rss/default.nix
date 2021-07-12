{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "tt-rss";
  version = "2021-06-21";
  rev = "cd26dbe64c9b14418f0b2d826a38a35c6bf8a270";

  src = fetchurl {
    url = "https://git.tt-rss.org/fox/tt-rss/archive/${rev}.tar.gz";
    sha256 = "1dpmzi7hknv5rk2g1iw13r8zcxcwrhkd5hhf292ml0dw3cwki0gm";
  };

  installPhase = ''
    mkdir $out
    cp -ra * $out/
  '';

  meta = with lib; {
    description = "Web-based news feed (RSS/Atom) aggregator";
    license = licenses.gpl2Plus;
    homepage = "https://tt-rss.org";
    maintainers = with maintainers; [ globin zohl ];
    platforms = platforms.all;
  };
}
