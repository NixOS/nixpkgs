{ stdenv, fetchurl }:

let

  version = "0.8.1";
  
in

stdenv.mkDerivation {
  name = "thinkfan-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/thinkfan/thinkfan-${version}.tar.gz";
    sha256 = "04akla66r8k10x0jvmcpfi92hj2sppygcl7hhwn8n8zsvvf0yqxs";
  };
  
  installPhase = ''
    mkdir -p $out/bin
    mv thinkfan $out/bin/
  '';

  meta = {
    description = "";
    license = stdenv.lib.licenses.gpl3;
    homepage = "http://thinkfan.sourceforge.net/";
    maintainers = with stdenv.lib.maintainers; [ iElectric ];
    platforms = stdenv.lib.platforms.linux;
  };
}
