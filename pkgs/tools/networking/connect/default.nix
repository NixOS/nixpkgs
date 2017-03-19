{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "connect-${version}";
  version ="1.105";

  src = fetchurl {
    url = "https://bitbucket.org/gotoh/connect/get/${version}.tar.bz2";
    sha256 = "00yld6yinc8s4xv3b8kbvzn2f4rja5dmp6ysv3n4847qn4k60dh7";
  };

  makeFlags = [ "CC=cc" ];      # gcc and/or clang compat

  installPhase = ''
    install -D -m ugo=rx connect $out/bin/connect
  '';

  meta = {
    description = "Make network connection via SOCKS and https proxy";
    longDescription = ''
      This proxy traversal tool is intended to assist OpenSSH (via ProxyCommand
      in ~/.ssh/config) and GIT (via $GIT_PROXY_COMMAND) utilize SOCKS and https proxies. 
      '';
    homepage = https://bitbucket.org/gotoh/connect/wiki/Home;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.gnu;
    maintainers = with stdenv.lib.maintainers; [ jcumming ];
  };
}
