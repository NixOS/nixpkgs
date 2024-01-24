{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonApplication rec {
  pname = "usbsdmux";
  version = "24.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Qt60QKRadFoPiHjmpx9tmid4K+6ixCN7JD7JHcT5MDE=";
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
