{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "diffstat-1.62";

  src = fetchurl {
    urls = [
      "ftp://ftp.invisible-island.net/diffstat/${name}.tgz"
      "https://invisible-mirror.net/archives/diffstat/${name}.tgz"
    ];
    sha256 = "07sr482y6iw7n7ddkba0w51kbjc99snvnijkn5ba2xzd8hv1h2bz";
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
