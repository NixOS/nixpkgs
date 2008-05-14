{fetchurl, stdenv}:

stdenv.mkDerivation rec {
  name = "diffstat-1.45";

  src = fetchurl {
    url = "ftp://invisible-island.net/diffstat/"+ name +".tgz";
    md5 = "cfe06ffcdbeaaa2fd296db867157ef78";
  };

  meta = {
    homepage = http://invisible-island.net/diffstat/;
    longDescription = "diffstat reads the output of diff and displays a
istogram of the insertions, deletions, and modifications per-file. It
s useful for reviewing large, complex patch files.";
  };
}
