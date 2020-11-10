{ stdenv, fetchFromGitHub, python3, openssl }:

python3.pkgs.buildPythonApplication rec {
  pname = "esptool";
  version = "2.7";

  src = fetchFromGitHub {
    owner = "espressif";
    repo = "esptool";
    rev = "v${version}";
    sha256 = "1p5hx0rhs986ffqz78rdxg7jayndsq632399xby39k17kvd3mb31";
  };

  checkInputs = with python3.pkgs; [ flake8 flake8-future-import flake8-import-order openssl ];
  propagatedBuildInputs = with python3.pkgs; [ pyserial pyaes ecdsa ];

  meta = with stdenv.lib; {
    description = "ESP8266 and ESP32 serial bootloader utility";
    homepage = "https://github.com/espressif/esptool";
    license = licenses.gpl2;
    maintainers = with maintainers; [ dezgeg dotlambda ];
    platforms = platforms.linux;
  };
}
