{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "reattach-to-user-namespace";
  version = "2.8";

  src = fetchurl {
    url = "https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard/archive/v${version}.tar.gz";
    sha256 = "0xxxdd26rcplhpvi2vy6crxadk3d1qkq4xry10lwq6dyya2jf6wb";
  };

  buildFlags = [ "ARCHES=x86_64" ];

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
