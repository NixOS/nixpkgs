{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonApplication rec {
  pname = "usbsdmux";
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-gCxwR5jxzkH22B6nxBwAd0HpwWMIj/zp5VROJ0IWq7c=";
  };

  # Remove the wrong GROUP=plugdev.
  # The udev rule already has TAG+="uaccess", which is sufficient.
  postPatch = ''
    substituteInPlace contrib/udev/99-usbsdmux.rules \
      --replace 'TAG+="uaccess", GROUP="plugdev"' 'TAG+="uaccess"'
  '';

  # usbsdmux is not meant to be used as an importable module and has no tests
  doCheck = false;

  postInstall = ''
    install -Dm0444 -t $out/lib/udev/rules.d/ contrib/udev/99-usbsdmux.rules
  '';

  meta = with lib; {
    description = "Control software for the LXA USB-SD-Mux";
    homepage = "https://github.com/linux-automation/usbsdmux";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ emantor ];
    platforms = with platforms; linux;
  };
}
