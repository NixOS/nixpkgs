{ stdenv, fetchgit }:

stdenv.mkDerivation {
  name = "reattach-to-user-namespace-2.5";

  src = fetchgit {
    url = "https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard.git";
    sha256 = "0kv11vi54g6waf9941hy1pwmwyab0y7hbmbkcgwhzb5ja21ysc2a";
    rev = "3689998acce9990726c8a68a85298ab693a62458";
  };

  buildFlags = "ARCHES=x86_64";

  installPhase = ''
    mkdir -p $out/bin
    cp reattach-to-user-namespace $out/bin/
  '';

  meta = {
    platforms = stdenv.lib.platforms.darwin;
  };
}
