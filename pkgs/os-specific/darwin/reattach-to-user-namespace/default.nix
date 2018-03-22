{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "reattach-to-user-namespace-${version}";
  version = "2.6";

  src = fetchurl {
    url = "https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard/archive/v2.6.tar.gz";
    sha256 = "1d8ynzkdlxyyky9f88f7z50g9lwdydkpb2n7gkw3jgl2ac569xc0";
  };

  buildFlags = "ARCHES=x86_64";

  installPhase = ''
    mkdir -p $out/bin
    cp reattach-to-user-namespace $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "A wrapper that provides access to the Mac OS X pasteboard service";
    license = licenses.bsd2;
    maintainers = with maintainers; [ lnl7 ];
    platforms = platforms.darwin;
  };
}
