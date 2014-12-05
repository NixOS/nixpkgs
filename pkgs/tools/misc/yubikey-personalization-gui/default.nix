{ stdenv, fetchurl, pkgconfig, yubikey-personalization, qt, libyubikey }:

stdenv.mkDerivation rec {
  name = "yubikey-personalization-gui-3.1.16";

  src = fetchurl {
    url = "https://developers.yubico.com/yubikey-personalization-gui/Releases/${name}.tar.gz";
    sha256 = "0sdiy2jn0anjvhnz47mrkblhh3paf0gmbgdmrkm21kws4f6sb4kh";
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
