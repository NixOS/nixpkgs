{
  buildPythonPackage,
  fetchPypi,
  lib,
  pyudev,
}:

buildPythonPackage rec {
  pname = "usb-monitor";
  version = "1.23";

  src = fetchPypi {
    inherit version;
    pname = "usb_monitor";
    hash = "sha256-7xZ30JLPduY0y2SHWI7fvZHB27FbNFAMczHMXnaXl88=";
  };

  dependencies = [ pyudev ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "usbmonitor" ];

  meta = {
    description = "Cross-platform library for USB device monitoring";
    homepage = "https://github.com/Eric-Canas/USBMonitor";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sifmelcara ];
    platforms = lib.platforms.linux;
  };
}
