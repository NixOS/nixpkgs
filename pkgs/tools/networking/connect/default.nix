{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "connect-1.95";
  
  src = fetchurl {
    url = http://savannah.gnu.org/maintenance/connect.c;
    sha256 = "11dx07pcanwaq71g4xh8d4blr5j7iy0ilmb0fkgpj8p22blb74mf";
  };

  phases = "unpackPhase buildPhase fixupPhase";

  unpackPhase = ''
    cp $src connect.c
  '';

  buildPhase = ''
    mkdir -p $out/bin
    gcc -o $out/bin/connect connect.c
  '';

  meta = {
    description = "Make network connection via SOCKS and https proxy";
    longDescription = ''
      This proxy traversal tool is intended to assist OpenSSH (via ProxyCommand
      in ~/.ssh/config) and GIT (via $GIT_PROXY_COMMAND) utilize SOCKS and https proxies. 
      '';
    homepage = http://bent.latency.net/bent/git/goto-san-connect-1.85/src/connect.html; # source URL is busted there
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.gnu;
    maintainers = with stdenv.lib.maintainers; [ jcumming ];
  };
}
