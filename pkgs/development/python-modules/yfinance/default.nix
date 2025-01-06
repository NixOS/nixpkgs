{
  lib,
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
  platformdirs,
  pythonOlder,
  pytz,
  requests-cache,
  requests-ratelimiter,
  requests,
  scipy,
  setuptools,
}:

buildPythonPackage rec {
  pname = "yfinance";
  version = "0.2.48";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ranaroussi";
    repo = "yfinance";
    rev = "refs/tags/${version}";
    hash = "sha256-7m5N2l80Cg6+NDiW0x49WtHkc6fu07s0BqKlHFCc1v0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    beautifulsoup4
    cryptography
    frozendict
    html5lib
    lxml
    multitasking
    numpy
    pandas
    peewee
    platformdirs
    pytz
    requests
  ];

  optional-dependencies = {
    nospam = [
      requests-cache
      requests-ratelimiter
    ];
    repair = [
      scipy
    ];
  };

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
