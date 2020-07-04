{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "mednafen-server";
  version = "0.5.2";

  src = fetchurl {
    url = "https://mednafen.github.io/releases/files/mednafen-server-${version}.tar.xz";
    sha256 = "0xm7dj5nwnrsv69r72rcnlw03jm0l8rmrg3s05gjfvxyqmlb36dq";
  };

  postInstall = "install -m 644 -Dt $out/share/mednafen-server standard.conf";

  meta = with stdenv.lib; {
    description = "Netplay server for Mednafen";
    homepage = "https://mednafen.github.io/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.linux;
  };
}
