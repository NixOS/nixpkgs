{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "diffstat-1.58";

  src = fetchurl {
    url = "ftp://invisible-island.net/diffstat/${name}.tgz";
    sha256 = "14rpf5c05ff30f6vn6pn6pzy0k4g4is5im656ahsxff3k58i7mgs";
  };

  meta = with stdenv.lib; {
    description = "Read output of diff and display a histogram of the changes";
    longDescription = ''
      diffstat reads the output of diff and displays a histogram of the
      insertions, deletions, and modifications per-file. It is useful for
      reviewing large, complex patch files.
    '';
    homepage = http://invisible-island.net/diffstat/;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.bjornfor ];
  };
}
