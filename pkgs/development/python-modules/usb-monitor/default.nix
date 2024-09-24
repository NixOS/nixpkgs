{
  buildPythonPackage,
  fetchPypi,
  lib,
  pyudev,
}:

buildPythonPackage rec {
  pname = "usb-monitor";
  version = "1.21";

  src = fetchPypi {
    inherit version;
    pname = "usb_monitor";
    hash = "sha256-M+BUmbNxQWcULFECexTnp55EZiJ6y3bYCEtSwqKldAk=";
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
