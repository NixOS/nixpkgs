{
  lib,
  fetchPypi,
  buildPythonPackage,
  scrapy,
  setuptools,
}:

buildPythonPackage rec {
  pname = "scrapy-deltafetch";
  version = "2.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-E/eWi9D/rhM+Kh3t4hXmg7jJUoXwRiYGA6XD4l8tV7A=";
  };

  dependencies = [ scrapy ];

  build-system = [ setuptools ];

  # no tests
  doCheck = false;
  pythonImportsCheck = [ "scrapy_deltafetch" ];

  meta = {
    description = "Scrapy spider middleware to ignore requests to pages containing items seen in previous crawls";
    homepage = "https://github.com/scrapy-plugins/scrapy-deltafetch";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ evanjs ];
  };
}
