{ stdenv, fetchurl }:

stdenv.mkDerivation rec {

  name = "mednafen-server-${meta.version}";

  src = fetchurl {
    url = "http://mednafen.fobby.net/releases/files/${name}.tar.gz";
    sha256="06fal6hwrb8gw94yp7plhcz55109128cgp35m7zs5vvjf1zfhcs9";
  };

  postInstall = ''
    mkdir -p $out/share/$name 
    install -m 644 -t $out/share/$name standard.conf
  '';

  meta = with stdenv.lib; {
    version = "0.5.2";
    description = "Netplay server for Mednafen";
    homepage = http://mednafen.sourceforge.net/;
    license = licenses.gpl2;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
