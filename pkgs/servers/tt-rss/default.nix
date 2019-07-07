{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "tt-rss-${version}";
  version = "2019-01-29";
  rev = "c7c9c5fb0ab6b3d4ea3078865670d6c1dfe2ecac";

  src = fetchurl {
    url = "https://git.tt-rss.org/git/tt-rss/archive/${rev}.tar.gz";
    sha256 = "0k184zqrfscv17gnl106q4yzhqmxb0g1dn1wkdkrclc3qcrviyp6";
  };

  installPhase = ''
    mkdir $out
    cp -ra * $out/
  '';

  meta = with stdenv.lib; {
    description = "Web-based news feed (RSS/Atom) aggregator";
    license = licenses.gpl2Plus;
    homepage = https://tt-rss.org;
    maintainers = with maintainers; [ globin zohl ];
    platforms = platforms.all;
  };
}
