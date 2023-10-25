{ lib
, fetchPypi
, buildPythonPackage
, click-plugins
, colorama
, requests
, setuptools
, pythonOlder
, xlsxwriter
}:

buildPythonPackage rec {
  pname = "shodan";
  version = "1.29.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4q9iVOGdKo+k6Slzi+VR4l3Hqvw5RzLndufjD6RM4zk=";
  };

  propagatedBuildInputs = [
    click-plugins
    colorama
    requests
    setuptools
    xlsxwriter
  ];

  # The tests require a shodan api key, so skip them.
  doCheck = false;

  pythonImportsCheck = [
    "shodan"
  ];

  meta = with lib; {
    description = "Python library and command-line utility for Shodan";
    homepage = "https://github.com/achillean/shodan-python";
    changelog = "https://github.com/achillean/shodan-python/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ lihop ];
  };
}
