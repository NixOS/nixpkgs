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
  version = "1.25.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-fivdvBtgv2IAQtABD0t2KoC0MRHb6pwEHXLUMl4mDCM=";
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
