{ lib
<<<<<<< HEAD
, buildPythonPackage
, click-plugins
, colorama
, fetchPypi
, pythonOlder
, requests
, setuptools
, tldextract
=======
, fetchPypi
, buildPythonPackage
, click-plugins
, colorama
, requests
, setuptools
, pythonOlder
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, xlsxwriter
}:

buildPythonPackage rec {
  pname = "shodan";
<<<<<<< HEAD
  version = "1.30.0";
=======
  version = "1.28.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-yWF8ZsR7h9SAHnCAtsdp7Jox2jmN7+CwR6Z5SSdDZFM=";
=======
    hash = "sha256-GL0q6BEUtwg24OMxUicyXhQ5gnUiOZiowjWwmUMvSws=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    click-plugins
    colorama
    requests
    setuptools
<<<<<<< HEAD
    tldextract
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    changelog = "https://github.com/achillean/shodan-python/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab lihop ];
=======
    license = licenses.mit;
    maintainers = with maintainers; [ lihop ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
