{ lib
, buildPythonPackage
, click-plugins
, colorama
, fetchPypi
, pythonOlder
, requests
, setuptools
, tldextract
, xlsxwriter
}:

buildPythonPackage rec {
  pname = "shodan";
  version = "1.30.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yWF8ZsR7h9SAHnCAtsdp7Jox2jmN7+CwR6Z5SSdDZFM=";
  };

  propagatedBuildInputs = [
    click-plugins
    colorama
    requests
    setuptools
    tldextract
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
    maintainers = with maintainers; [ fab lihop ];
  };
}
