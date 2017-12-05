{ stdenv, fetchFromGitHub, python3, openssl }:

python3.pkgs.buildPythonApplication rec {
  name = "esptool-${version}";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "espressif";
    repo = "esptool";
    rev = "v${version}";
    sha256 = "137p0kcscly95qpjzgx1yxm8k2wf5y9v3srvlhp2ajniirgv8ijv";
  };

  buildInputs = with python3.pkgs; [ flake8 flake8-future-import ];
  propagatedBuildInputs = with python3.pkgs; [ pyserial pyaes ecdsa openssl ];

  meta = with stdenv.lib; {
    description = "ESP8266 and ESP32 serial bootloader utility";
    homepage = https://github.com/espressif/esptool;
    license = licenses.gpl2;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}
