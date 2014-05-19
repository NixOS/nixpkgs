{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "reattach-to-user-namespace-2.2";

  src = fetchurl {
    url = "https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard/archive/v2.2.tar.gz";
    sha256 = "02xd0lbjhv5ilj1mds6gr65023vghsz6v2c9r87d9bid3cvsb9s3";
  };

  buildPhase = ''
    make reattach-to-user-namespace ARCHES=x86_64
  '';

  installPhase = ''
    mkdir -p $out/bin;
    cp reattach-to-user-namespace $out/bin/reattach-to-user-namespace;
  '';

  preCheck = ''
    make test ARCHES=x86_64;
  '';

  checkPhase = ''
    ./test;
  '';

  meta = {
    description = "Enable programs inside tmux to use the system pasteboard.";
    homepage = https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard;
    platforms = stdenv.lib.platforms.darwin;
    maintainers = with stdenv.lib.maintainers; [ joelteon ];
  };
}
