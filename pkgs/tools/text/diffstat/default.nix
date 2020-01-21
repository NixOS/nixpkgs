{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "diffstat-1.63";

  src = fetchurl {
    urls = [
      "ftp://ftp.invisible-island.net/diffstat/${name}.tgz"
      "https://invisible-mirror.net/archives/diffstat/${name}.tgz"
    ];
    sha256 = "0vyw200s5dv1257pmrh6c6fdkmw3slyz5szpqfx916xr04sdbpby";
  };

  meta = with stdenv.lib; {
    description = "Read output of diff and display a histogram of the changes";
    longDescription = ''
      diffstat reads the output of diff and displays a histogram of the
      insertions, deletions, and modifications per-file. It is useful for
      reviewing large, complex patch files.
    '';
    homepage = https://invisible-island.net/diffstat/;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.bjornfor ];
  };
}
