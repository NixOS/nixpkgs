{ stdenv, fetchFromGitHub, python3, openssl }:

python3.pkgs.buildPythonApplication rec {
  name = "esptool-${version}";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "espressif";
    repo = "esptool";
    rev = "v${version}";
    sha256 = "0gwnl6z5s2ax07l3n38h9hdyz71pn8lzn4fybcwyrii0bj2kapvc";
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
