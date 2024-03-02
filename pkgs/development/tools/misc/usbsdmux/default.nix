{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonApplication rec {
  pname = "usbsdmux";
  version = "24.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-OtGgToDGUr6pBu9+LS/DxaYw/9+Pd6jPhxVDAM22HB4=";
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
