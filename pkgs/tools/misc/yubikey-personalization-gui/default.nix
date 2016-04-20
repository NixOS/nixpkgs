{ stdenv, fetchurl, pkgconfig, yubikey-personalization, qt4, qmake4Hook, libyubikey }:

stdenv.mkDerivation rec {
  name = "yubikey-personalization-gui-3.1.24";

  src = fetchurl {
    url = "https://developers.yubico.com/yubikey-personalization-gui/Releases/${name}.tar.gz";
    sha256 = "0aj8cvajswkwzig0py0mjnfw0m8xsilisdcnixpjx9xxsxz5yacq";
  };

  nativeBuildInputs = [ pkgconfig qmake4Hook ];
  buildInputs = [ yubikey-personalization qt4 libyubikey ];
  
  installPhase = ''
    mkdir -p $out/bin
    cp build/release/yubikey-personalization-gui $out/bin
  '';

  meta = with stdenv.lib; {
    homepage = https://developers.yubico.com/yubikey-personalization-gui;
    description = "a QT based cross-platform utility designed to facilitate reconfiguration of the Yubikey";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };
}
