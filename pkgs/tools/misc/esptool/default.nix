{ stdenv, fetchFromGitHub, python3, openssl }:

python3.pkgs.buildPythonApplication rec {
  pname = "esptool";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "espressif";
    repo = "esptool";
    rev = "v${version}";
    sha256 = "19l3b1fqg1n3ch484dcibbi5a3nbmjq086has5pwqn348h4k57mh";
  };

  checkInputs = with python3.pkgs; [ flake8 flake8-future-import flake8-import-order ];
  propagatedBuildInputs = with python3.pkgs; [ pyserial pyaes ecdsa openssl ];

  meta = with stdenv.lib; {
    description = "ESP8266 and ESP32 serial bootloader utility";
    homepage = https://github.com/espressif/esptool;
    license = licenses.gpl2;
    maintainers = with maintainers; [ dezgeg dotlambda ];
    platforms = platforms.linux;
  };
}
