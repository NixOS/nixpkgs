{ lib
, fetchPypi
, buildPythonPackage
, click-plugins
, colorama
, requests
, setuptools
, pythonOlder
, XlsxWriter
}:

buildPythonPackage rec {
  pname = "shodan";
  version = "1.28.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-GL0q6BEUtwg24OMxUicyXhQ5gnUiOZiowjWwmUMvSws=";
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

  pythonImportsCheck = [
    "shodan"
  ];

  meta = with lib; {
    description = "Python library and command-line utility for Shodan";
    homepage = "https://github.com/achillean/shodan-python";
    license = licenses.mit;
    maintainers = with maintainers; [ lihop ];
  };
}
