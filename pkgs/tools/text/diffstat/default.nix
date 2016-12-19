{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "diffstat-1.61";

  src = fetchurl {
    url = "ftp://invisible-island.net/diffstat/${name}.tgz";
    sha256 = "1vjmda2zfjxg0qkaj8hfqa8g6bfwnn1ja8696rxrjgqq4w69wd95";
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
