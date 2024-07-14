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
    hash = "sha256-E/eWi9D/rhM+Kh3t4hXmg7jJUoXwRiYGA6XD4l8tV7A=";
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
