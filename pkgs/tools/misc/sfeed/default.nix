{ stdenv, lib, fetchgit }:

stdenv.mkDerivation rec {
  pname = "sfeed";
  version = "1.0";

  src = fetchgit {
    url = "git://git.codemadness.org/sfeed";
    rev = version;
    sha256 = "sha256-pLKWq4KIiT6X37EUIOw5SBb1KWopnFcDO+iE++Uie5s=";
  };

  installPhase = ''
    mkdir $out
    make install PREFIX=$out
  '';

  meta = with lib; {
    homepage = "https://codemadness.org/sfeed-simple-feed-parser.html";
    description = "A RSS and Atom parser (and some format programs)";
    longDescription = ''
      It converts RSS or Atom feeds from XML to a TAB-separated file. There are
      formatting programs included to convert this TAB-separated format to
      various other formats. There are also some programs and scripts included
      to import and export OPML and to fetch, filter, merge and order feed
      items.
    '';
    license = licenses.isc;
    maintainers = [ maintainers.matthiasbeyer ];
    platforms = platforms.all;
  };
}
