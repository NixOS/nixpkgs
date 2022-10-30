{ lib, stdenv, fetchgit }:

stdenv.mkDerivation rec {
  pname = "tt-rss";
  version = "unstable-2022-10-15";

  src = fetchgit {
    url = "https://git.tt-rss.org/fox/tt-rss.git";
    rev = "602e8684258062937d7f554ab7889e8e02318c96";
    sha256 = "sha256-vgRaxo998Gx9rVeZZl52jppK1v11jpEK0J0NoDMT44I=";
  };

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -ra * $out/

    # see the code of Config::get_version(). you can check that the version in
    # the footer of the preferences pages is not UNKNOWN
    echo "22.10" > $out/version_static.txt

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
