{ lib, stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  pname = "proxytunnel";
  version = "1.9.0";

  src = fetchurl {
    url = "mirror://sourceforge/proxytunnel/proxytunnel-${version}.tgz";
    sha256 = "1fd644kldsg14czkqjybqh3wrzwsp3dcargqf4fjkpqxv3wbpx9f";
  };

  buildInputs = [ openssl ];

  installPhase = ''make DESTDIR="$out" PREFIX="" install'';

  meta = {
    description = "Program that connects stdin and stdout to a server somewhere on the network, through a standard HTTPS proxy";
    homepage = "http://proxytunnel.sourceforge.net/download.php";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
}
