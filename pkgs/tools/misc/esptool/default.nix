{ stdenv, fetchFromGitHub, python3 }:

python3.pkgs.buildPythonApplication rec {
  name = "esptool-${version}";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "espressif";
    repo = "esptool";
    rev = "v${version}";
    sha256 = "0112fybkz4259gyvhcs18wa6938jp6w7clk66kpd0d1dg70lz1h6";
  };

  propagatedBuildInputs = with python3.pkgs; [ pyserial ];

  doCheck = false; # FIXME: requires packaging some new deps

  meta = with stdenv.lib; {
    description = "ESP8266 and ESP32 serial bootloader utility";
    homepage = https://github.com/espressif/esptool;
    license = licenses.gpl2;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}
