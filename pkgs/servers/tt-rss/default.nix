{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  name = "tt-rss-${version}";
  version = "16.3";

  src = fetchgit {
    url = "https://tt-rss.org/gitlab/fox/tt-rss.git";
    rev = "refs/tags/${version}";
    sha256 = "1584lcq6kcy9f8ik5djb9apck9hxvfpl54sn6yhl3pdfrfdj3nw5";
  };

  buildPhases = ["unpackPhase" "installPhase"];

  installPhase = ''
    mkdir $out
    cp -ra * $out/
  '';

  meta = with stdenv.lib; {
    description = "Web-based news feed (RSS/Atom) aggregator";
    license = licenses.gpl2Plus;
    homepage = http://tt-rss.org;
    maintainers = with maintainers; [ zohl ];
    platforms = platforms.all;
  };
}

