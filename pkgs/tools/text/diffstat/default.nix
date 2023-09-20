{ fetchurl, lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "diffstat";
  version = "1.65";

  src = fetchurl {
    urls = [
      "ftp://ftp.invisible-island.net/diffstat/diffstat-${version}.tgz"
      "https://invisible-mirror.net/archives/diffstat/diffstat-${version}.tgz"
    ];
    sha256 = "sha256-jPJ0JJJt682FkhdVw5FVWSiCRL0QP2LXQNxrg7VXooo=";
  };

  meta = with lib; {
    description = "Read output of diff and display a histogram of the changes";
    longDescription = ''
      diffstat reads the output of diff and displays a histogram of the
      insertions, deletions, and modifications per-file. It is useful for
      reviewing large, complex patch files.
    '';
    homepage = "https://invisible-island.net/diffstat/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.bjornfor ];
  };
}
