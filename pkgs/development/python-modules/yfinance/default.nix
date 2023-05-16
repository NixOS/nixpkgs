{ lib
, appdirs
, beautifulsoup4
, buildPythonPackage
, cryptography
, fetchFromGitHub
, frozendict
<<<<<<< HEAD
, html5lib
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, multitasking
, numpy
, pandas
, pythonOlder
, requests
, lxml
}:

buildPythonPackage rec {
  pname = "yfinance";
<<<<<<< HEAD
  version = "0.2.28";
=======
  version = "0.2.19b1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ranaroussi";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-kTbQnpha4OHu5Xguo6v90uFpcXY1e8JJsJUo4ZbaCfk=";
=======
    hash = "sha256-kqNit24Fdi6rk0WIJnTIata3o+pkGOGAVWZkzTlZdsQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    appdirs
    beautifulsoup4
    cryptography
    frozendict
<<<<<<< HEAD
    html5lib
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    multitasking
    numpy
    pandas
    requests
    lxml
  ];

  # Tests require internet access
  doCheck = false;

  pythonImportsCheck = [
    "yfinance"
  ];

  meta = with lib; {
    description = "Module to doiwnload Yahoo! Finance market data";
    homepage = "https://github.com/ranaroussi/yfinance";
    changelog = "https://github.com/ranaroussi/yfinance/blob/${version}/CHANGELOG.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
