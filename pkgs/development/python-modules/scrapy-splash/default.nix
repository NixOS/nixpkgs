{ lib, fetchPypi, buildPythonPackage, scrapy, six }:

buildPythonPackage rec {
  pname = "scrapy-splash";
  version = "0.9.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7PEwJk3AjgxGHIYH7K13dGimStAd7bJinA+BvV/NcpU=";
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
