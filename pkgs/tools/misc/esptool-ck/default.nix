{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "esptool-ck-${version}";
  version = "0.4.11";

  src = fetchFromGitHub {
    owner = "igrr";
    repo = "esptool-ck";
    rev = "0.4.11";
    sha256 = "086x68jza24xkaap8nici18kj78id2p2lzbasin98wilvpjc8d7f";
  };

  makeFlags = [ "VERSION=${version}" ];

  installPhase = ''
    mkdir -p $out/bin
    cp esptool $out/bin
  '';

  meta = with stdenv.lib; {
    description = "ESP8266/ESP32 build helper tool";
    homepage = https://github.com/igrr/esptool-ck;
    license = licenses.gpl2;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}
