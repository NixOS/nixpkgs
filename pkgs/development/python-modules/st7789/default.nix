{
  lib,
  fetchPypi,
  buildPythonPackage,
  hatchling,
  hatch-fancy-pypi-readme,
  gpiod,
  spidev,
  numpy,
  gpiodevice,
}:

buildPythonPackage rec {
  pname = "st7789";
  version = "1.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "st7789";
    sha256 = "sha256-8gSYPRnTXiZlBFWsfim9eybUItRw8JOZRAP2347N3Bs=";
  };

  build-system = [ hatchling ];

  dependencies = [
    hatch-fancy-pypi-readme
    gpiod
    spidev
    numpy
    gpiodevice
  ];

  doCheck = false;

  pythonImportsCheck = [ "st7789" ];

  meta = {
    homepage = "https://github.com/pimoroni/st7789-python";
    description = "Python library to control an ST7789 240x240 1.3\" TFT LCD display.";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cktiel ];
  };
}
