{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "esptool-ck";
  version = "0.4.13";

  src = fetchFromGitHub {
    owner = "igrr";
    repo = "esptool-ck";
    rev = "0.4.13";
    sha256 = "1cb81b30a71r7i0gmkh2qagfx9lhq0myq5i37fk881bq6g7i5n2k";
  };

  makeFlags = [ "VERSION=${version}" ];

  installPhase = ''
    mkdir -p $out/bin
    cp esptool $out/bin
  '';

  meta = with lib; {
    description = "ESP8266/ESP32 build helper tool";
    homepage = "https://github.com/igrr/esptool-ck";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
    mainProgram = "esptool";
  };
}
