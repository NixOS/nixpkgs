{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "usbsdmux";
  version = "0.1.8";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "0m3d0rs9s5v5hnsjkfybmd8v54gn7rc1dbg5vc48rryhc969pr9f";
  };

  meta = with lib; {
    description = "Control software for the LXA USB-SD-Mux";
    homepage = "https://github.com/linux-automation/usbsdmux";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ emantor ];
    platforms = with platforms; linux;
  };
}
