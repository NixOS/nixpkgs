{ lib
, appdirs
, beautifulsoup4
, buildPythonPackage
, cryptography
, fetchFromGitHub
, frozendict
, multitasking
, numpy
, pandas
, pythonOlder
, requests
, lxml
}:

buildPythonPackage rec {
  pname = "yfinance";
  version = "0.2.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ranaroussi";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-WWqRj6It2sYZk1gV3+D94wFbOfzBhIngygalTSwVwaI=";
  };

  propagatedBuildInputs = [
    appdirs
    beautifulsoup4
    cryptography
    frozendict
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
