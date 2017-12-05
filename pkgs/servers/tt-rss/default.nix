{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  name = "tt-rss-${version}";
  version = "17.4";

  src = fetchgit {
    url = "https://git.tt-rss.org/git/tt-rss.git";
    rev = "refs/tags/${version}";
    sha256 = "07ng21n4pva56cxnxkzd6vzs381zn67psqpm51ym5wnl644jqh08";
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

