{
  lib,
  appdirs,
  beautifulsoup4,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  frozendict,
  html5lib,
  lxml,
  multitasking,
  numpy,
  pandas,
  peewee,
  pythonOlder,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "yfinance";
  version = "0.2.38";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ranaroussi";
    repo = "yfinance";
    rev = "refs/tags/${version}";
    hash = "sha256-ZGwtu2vLcE9pM73umhnFwSzjQnGjTOTtVF607ox7I6E=";
  };

  build-system = [ setuptools ];

  dependencies = [
    appdirs
    beautifulsoup4
    cryptography
    frozendict
    html5lib
    lxml
    multitasking
    numpy
    pandas
    peewee
    requests
  ];

  # Tests require internet access
  doCheck = false;

  pythonImportsCheck = [ "yfinance" ];

  meta = with lib; {
    description = "Module to doiwnload Yahoo! Finance market data";
    homepage = "https://github.com/ranaroussi/yfinance";
    changelog = "https://github.com/ranaroussi/yfinance/blob/${version}/CHANGELOG.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
