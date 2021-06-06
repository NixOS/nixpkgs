{ lib, fetchPypi, buildPythonPackage, scrapy, six }:

buildPythonPackage rec {
  pname = "scrapy-splash";
  version = "0.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1dg7csdza2hzqskd9b9gx0v3saqsch4f0fwdp0a3p0822aqqi488";
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
