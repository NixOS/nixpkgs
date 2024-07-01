{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "spidev";
  version = "3.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FNvDdZSkqu+FQDq2F5hdPD70ZNYrybdp71UttTcBEVs=";
  };

  # package does not include tests
  doCheck = false;

  pythonImportsCheck = [ "spidev" ];

  meta = with lib; {
    homepage = "https://github.com/doceme/py-spidev";
    description = "Python bindings for Linux SPI access through spidev";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
    platforms = platforms.linux;
  };
}
