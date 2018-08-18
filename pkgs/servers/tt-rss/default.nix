{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "tt-rss-${version}";
  version = "2018-04-05";
  rev = "963c22646b3e1bd544bd957bf34175b996bd6e53";

  src = fetchurl {
    url = "https://git.tt-rss.org/git/tt-rss/archive/${rev}.tar.gz";
    sha256 = "02vjw5cag5x0rpiqalfrqf7iz21rp8ml5wnfd8pdkxbr8182bw3h";
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
