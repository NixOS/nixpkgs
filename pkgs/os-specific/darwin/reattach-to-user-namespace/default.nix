{ stdenv, fetchgit }:

stdenv.mkDerivation {
  name = "reattach-to-user-namespace-2.4";
  src = fetchgit {
    url = "https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard.git";
    sha256 = "1f9q1wxq764zidnx5hbdkbbyxxzfih0l0cjpgr0pxzwbmd2q6cvv";
    rev = "2765aeab8f337c29e260a912bf4267a2732d8640";
  };
  buildFlags = "ARCHES=x86_64";
  installPhase = ''
    mkdir -p $out/bin
    cp reattach-to-user-namespace $out/bin/
  '';
}

