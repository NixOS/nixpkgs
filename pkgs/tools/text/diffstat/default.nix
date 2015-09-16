{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "diffstat-1.60";

  src = fetchurl {
    url = "ftp://invisible-island.net/diffstat/${name}.tgz";
    sha256 = "08q1zckb3q5xpqa17pl14fbi5b64xc0sjbg393ap1bivnhcf8ci0";
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
