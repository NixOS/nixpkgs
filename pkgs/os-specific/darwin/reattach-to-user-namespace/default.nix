{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "reattach-to-user-namespace";
  version = "2.7";

  src = fetchurl {
    url = "https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard/archive/v${version}.tar.gz";
    sha256 = "00mjyj8yicrpnlm46rlbkvxgl5381l8xawh7rmjk10p3zrm56jbv";
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
