{ lib
, fetchPypi
, buildPythonPackage
, click-plugins
, colorama
, requests
, setuptools
, XlsxWriter
}:

buildPythonPackage rec {
  pname = "shodan";
  version = "1.23.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d2d37d47dd084747df672e6d981f6d72d5d03f4ee12f0ce2170e618147578349";
  };

  propagatedBuildInputs = [
    click-plugins
    colorama
    requests
    setuptools
    XlsxWriter
  ];

  # The tests require a shodan api key, so skip them.
  doCheck = false;

  meta = with lib; {
    description = "Python library and command-line utility for Shodan";
    homepage = "https://github.com/achillean/shodan-python";
    license = licenses.mit;
    maintainers = with maintainers; [ lihop ];
  };
}
