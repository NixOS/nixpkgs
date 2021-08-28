{ stdenv, lib, fetchgit }:

stdenv.mkDerivation rec {
  pname = "sfeed";
  version = "0.9.21";

  src = fetchgit {
    url = "git://git.codemadness.org/sfeed";
    rev = version;
    sha256 = "010wasp6hcnwbf0d3gaxmjpkvr85zyv2xxz2pnkwxyk2bbr1h6q8";
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
