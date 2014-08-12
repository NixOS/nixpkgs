{ stdenv, fetchurl }:

stdenv.mkDerivation rec {

  name = "mednafen-server-${version}";
  version = "0.5.1";

  src = fetchurl {
    url = "http://downloads.sourceforge.net/project/mednafen/Mednafen-Server/${version}/${name}.tar.gz";
    sha256="0c5wvg938y3h4n5lb0dl8pvmjzphhkbba34r6ikpvdahq166ps4j";
  };

  postInstall = ''
    mkdir -p $out/share/$name 
    install -m 644 -t $out/share/$name standard.conf
  '';

  meta = {
    description = "Netplay server for Mednafen";
    homepage = http://mednafen.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.AndersonTorres ];
    platforms = stdenv.lib.platforms.linux;
  };
}
