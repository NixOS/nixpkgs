{
  lib,
  fetchPypi,
  buildPythonPackage,
  scrapy,
  bsddb3,
}:

buildPythonPackage rec {
  pname = "scrapy-deltafetch";
  version = "2.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "13f7968bd0ffae133e2a1dede215e683b8c95285f046260603a5c3e25f2d57b0";
  };

  propagatedBuildInputs = [
    bsddb3
    scrapy
  ];

  # no tests
  doCheck = false;
  pythonImportsCheck = [ "scrapy_deltafetch" ];

  meta = with lib; {
    description = "Scrapy spider middleware to ignore requests to pages containing items seen in previous crawls";
    homepage = "https://github.com/scrapy-plugins/scrapy-deltafetch";
    license = licenses.bsd3;
    maintainers = with maintainers; [ evanjs ];
  };
}
