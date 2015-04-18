{ stdenv, fetchurl }:

let

  version = "1.104";

in stdenv.mkDerivation {
  name = "connect-${version}";
  
  src = fetchurl {
    url = "https://bitbucket.org/gotoh/connect/get/${version}.tar.bz2";
    sha256 = "0h7bfh1b2kcw5ddpbif57phdxpf8if0cm01pgwc6avp6dqxcsqp2";
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
