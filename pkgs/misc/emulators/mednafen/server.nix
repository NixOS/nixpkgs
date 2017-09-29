{ stdenv, fetchurl }:

stdenv.mkDerivation rec {

  name = "mednafen-server-${version}";
  version = "0.5.2";

  src = fetchurl {
    url = "https://mednafen.github.io/releases/files/mednafen-server-0.5.2.tar.xz";
    sha256 = "0xm7dj5nwnrsv69r72rcnlw03jm0l8rmrg3s05gjfvxyqmlb36dq";
  };

  postInstall = ''
    mkdir -p $out/share/$name
    install -m 644 -t $out/share/$name standard.conf
  '';

  meta = with stdenv.lib; {
    description = "Netplay server for Mednafen";
    homepage = http://mednafen.github.io/;
    license = licenses.gpl2;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
