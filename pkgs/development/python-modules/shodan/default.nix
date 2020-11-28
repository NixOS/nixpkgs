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
  version = "1.24.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0b5ec40c954cd48c4e3234e81ad92afdc68438f82ad392fed35b7097eb77b6dd";
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
