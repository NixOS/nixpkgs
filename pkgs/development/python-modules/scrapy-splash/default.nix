{ lib, fetchPypi, buildPythonPackage, scrapy, six }:

buildPythonPackage rec {
  pname = "scrapy-splash";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a7c17735415151ae01f07b03c7624e7276a343779b3c5f4546f655f6133df42f";
  };

  propagatedBuildInputs = [ scrapy six ];

  # no tests
  doCheck = false;
  pythonImportsCheck = [ "scrapy_splash" ];

  meta = with lib; {
    description = "Scrapy+Splash for JavaScript integration";
    homepage = "https://github.com/scrapy-plugins/scrapy-splash";
    license = licenses.bsd3;
    maintainers = with maintainers; [ evanjs ];
  };
}
