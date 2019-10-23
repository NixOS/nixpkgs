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
  version = "1.17.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1sh7a2dsal3kzcl4s9xbpl7hxhm9k55s5hiqdqqnafhvhnh0vmbz";
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
    homepage = https://github.com/achillean/shodan-python;
    license = licenses.mit;
    maintainers = with maintainers; [ lihop ];
  };
}
