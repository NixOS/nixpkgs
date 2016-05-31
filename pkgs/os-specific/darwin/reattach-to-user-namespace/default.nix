{ stdenv, fetchgit }:

stdenv.mkDerivation {
  name = "reattach-to-user-namespace-2.4";
  src = fetchgit {
    url = "https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard.git";
    sha256 = "0hrh95di5dvpynq2yfcrgn93l077h28i6msham00byw68cx0dd3z";
    rev = "2765aeab8f337c29e260a912bf4267a2732d8640";
  };
  buildFlags = "ARCHES=x86_64";
  installPhase = ''
    mkdir -p $out/bin
    cp reattach-to-user-namespace $out/bin/
  '';
}

