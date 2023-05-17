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
  version = "1.29.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6+ptvBlESX6ROSY0I+pNED3NWMCFxd2/TWqx226x0UI=";
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
