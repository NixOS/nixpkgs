{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "diffstat-1.59";

  src = fetchurl {
    url = "ftp://invisible-island.net/diffstat/${name}.tgz";
    sha256 = "0w7jvfilbnfa9v3h8j8ipirvrj7n2x5gszfanzxvx748p10i8z96";
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
