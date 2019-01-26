{ stdenv, fetchFromGitHub, python3, openssl }:

python3.pkgs.buildPythonApplication rec {
  pname = "esptool";
  version = "2.6";

  src = fetchFromGitHub {
    owner = "espressif";
    repo = "esptool";
    rev = "v${version}";
    sha256 = "1hxgzqh5z81dq1k2xd6329h8idk9y8q29izrwm1vhn0m9v1pxa22";
  };

  checkInputs = with python3.pkgs; [ flake8 flake8-future-import flake8-import-order openssl ];
  propagatedBuildInputs = with python3.pkgs; [ pyserial pyaes ecdsa ];

  meta = with stdenv.lib; {
    description = "ESP8266 and ESP32 serial bootloader utility";
    homepage = https://github.com/espressif/esptool;
    license = licenses.gpl2;
    maintainers = with maintainers; [ dezgeg dotlambda ];
    platforms = platforms.linux;
  };
}
