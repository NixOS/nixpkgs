{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "tt-rss";
  year = "21";
  month = "06";
  day = "21";
  version = "20${year}-${month}-${day}";
  rev = "cd26dbe64c9b14418f0b2d826a38a35c6bf8a270";

  src = fetchurl {
    url = "https://git.tt-rss.org/fox/tt-rss/archive/${rev}.tar.gz";
    sha256 = "1dpmzi7hknv5rk2g1iw13r8zcxcwrhkd5hhf292ml0dw3cwki0gm";
  };

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -ra * $out/

    # see the code of Config::get_version(). you can check that the version in
    # the footer of the preferences pages is not UNKNOWN
    echo "${year}.${month}" > $out/version_static.txt

    runHook postInstall
  '';

  meta = with lib; {
    description = "Web-based news feed (RSS/Atom) aggregator";
    license = licenses.gpl2Plus;
    homepage = "https://tt-rss.org";
    maintainers = with maintainers; [ globin zohl ];
    platforms = platforms.all;
  };
}
