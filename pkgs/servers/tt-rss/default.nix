{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "tt-rss-${version}";
  version = "2018-01-05";
  rev = "c30f5e18119d1935e8fe6d422053b127e8f4f1b3";

  src = fetchurl {
    url = "https://git.tt-rss.org/git/tt-rss/archive/${rev}.tar.gz";
    sha256 = "18pc1l0dbjr7d5grcrb70y6j7cr2zb9575yqmy6zfwzrlvw0pa0l";
  };

  installPhase = ''
    mkdir $out
    cp -ra * $out/
  '';

  meta = with stdenv.lib; {
    description = "Web-based news feed (RSS/Atom) aggregator";
    license = licenses.gpl2Plus;
    homepage = http://tt-rss.org;
    maintainers = with maintainers; [ globin zohl ];
    platforms = platforms.all;
  };
}
