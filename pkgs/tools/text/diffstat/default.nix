{fetchurl, stdenv}:

stdenv.mkDerivation rec {
  name = "diffstat-1.58";

  src = fetchurl {
    url = "ftp://invisible-island.net/diffstat/"+ name +".tgz";
    sha256 = "14rpf5c05ff30f6vn6pn6pzy0k4g4is5im656ahsxff3k58i7mgs";
  };

  meta = {
    homepage = http://invisible-island.net/diffstat/;
    longDescription = "diffstat reads the output of diff and displays a
istogram of the insertions, deletions, and modifications per-file. It
s useful for reviewing large, complex patch files.";
  };
}
