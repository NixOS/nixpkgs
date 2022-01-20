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
  version = "1.26.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f2827b40d6918988ef9f5f16dcb8a13383aaae1a2845898f7012eac8906bbb87";
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
  pythonImportsCheck = [ "shodan" ];

  meta = with lib; {
    description = "Python library and command-line utility for Shodan";
    homepage = "https://github.com/achillean/shodan-python";
    license = licenses.mit;
    maintainers = with maintainers; [ lihop ];
  };
}
