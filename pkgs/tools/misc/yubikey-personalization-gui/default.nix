{ stdenv, fetchurl, pkgconfig, yubikey-personalization, qt, libyubikey }:

stdenv.mkDerivation rec {
  name = "yubikey-personalization-gui-3.1.18";

  src = fetchurl {
    url = "https://developers.yubico.com/yubikey-personalization-gui/Releases/${name}.tar.gz";
    sha256 = "1jxi7izg9j4nd2jxra7pc18wp2b6a9i9zyix8yzvwkl4yjzpbqw3";
  };

  buildInputs = [ pkgconfig yubikey-personalization qt libyubikey ];
  
  configurePhase = ''
    qmake
  '';

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
