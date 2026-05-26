{
  lib,
  fetchPypi,
  buildPythonPackage,
  scrapy,
  setuptools,
}:

buildPythonPackage rec {
  pname = "scrapy-deltafetch";
  version = "2.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZtvB10g6j/JNcpyLZJS4R+8DC7TYg0MWQMvM0ncaJxM=";
  };

  dependencies = [ scrapy ];

  build-system = [ setuptools ];

  # no tests
  doCheck = false;
  pythonImportsCheck = [ "scrapy_deltafetch" ];

  meta = {
    # https://github.com/scrapy-plugins/scrapy-deltafetch/pull/50
    broken = lib.versionAtLeast scrapy.version "2.12";
    description = "Scrapy spider middleware to ignore requests to pages containing items seen in previous crawls";
    homepage = "https://github.com/scrapy-plugins/scrapy-deltafetch";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ evanjs ];
  };
}
