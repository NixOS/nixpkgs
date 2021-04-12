{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "usbsdmux";
  version = "0.2.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "sha256-ydDUSqBTY62iOtWdgrFh2qrO9LMi+OCYIw5reh6uoIA=";
  };

  # usbsdmux is not meant to be used as an importable module and has no tests
  doCheck = false;

  meta = with lib; {
    description = "Control software for the LXA USB-SD-Mux";
    homepage = "https://github.com/linux-automation/usbsdmux";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ emantor ];
    platforms = with platforms; linux;
  };
}
