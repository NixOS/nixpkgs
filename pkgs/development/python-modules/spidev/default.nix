{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "spidev";
  version = "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03cicc9kpi5khhq0bl4dcy8cjcl2j488mylp8sna47hnkwl5qzwa";
  };

  # package does not include tests
  doCheck = false;

  pythonImportsCheck = [ "spidev" ];

  meta = with lib; {
    homepage = "https://github.com/doceme/py-spidev";
    description = "Python bindings for Linux SPI access through spidev";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };

}
