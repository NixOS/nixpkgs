{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "connect";
  version ="1.105";

  src = fetchurl {
    url = "https://bitbucket.org/gotoh/connect/get/${version}.tar.bz2";
    sha256 = "00yld6yinc8s4xv3b8kbvzn2f4rja5dmp6ysv3n4847qn4k60dh7";
  };

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];      # gcc and/or clang compat

  installPhase = ''
    install -D -m ugo=rx connect $out/bin/connect
  '';

  meta = {
    description = "Make network connection via SOCKS and https proxy";
    longDescription = ''
      This proxy traversal tool is intended to assist OpenSSH (via ProxyCommand
      in ~/.ssh/config) and GIT (via $GIT_PROXY_COMMAND) utilize SOCKS and https proxies.
      '';
    homepage = "https://bitbucket.org/gotoh/connect/wiki/Home";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.gnu ++ lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ jcumming ];
    mainProgram = "connect";
  };
}
