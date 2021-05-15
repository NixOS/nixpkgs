{ fetchurl, lib, stdenv }:

stdenv.mkDerivation rec {
  name = "diffstat-1.64";

  src = fetchurl {
    urls = [
      "ftp://ftp.invisible-island.net/diffstat/${name}.tgz"
      "https://invisible-mirror.net/archives/diffstat/${name}.tgz"
    ];
    sha256 = "sha256-uK7jjZ0uHQWSbmtVgQqdLC3UB/JNaiZzh1Y6RDbj9/w=";
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
