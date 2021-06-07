{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "tt-rss";
  version = "2021-01-29";
  rev = "6d8f2221b82b6a31becbeed8baf5e05ad9e053fe";

  src = fetchurl {
    url = "https://git.tt-rss.org/fox/tt-rss/archive/${rev}.tar.gz";
    sha256 = "124c62hck631xlq5aa1miz9rbg711ygk7z1yx92m5dfcy630l7x5";
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
