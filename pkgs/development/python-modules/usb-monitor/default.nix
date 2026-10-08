{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pyudev,
}:

buildPythonPackage (finalAttrs: {
  pname = "usb-monitor";
  version = "1.23";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "usb_monitor";
    hash = "sha256-7xZ30JLPduY0y2SHWI7fvZHB27FbNFAMczHMXnaXl88=";
  };

  build-system = [ setuptools ];

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
})
