{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  cryptography,
  curl-cffi,
  fetchFromGitHub,
  frozendict,
  html5lib,
  lxml,
  multitasking,
  numpy,
  pandas,
  peewee,
  platformdirs,
  pytz,
  requests-cache,
  requests-ratelimiter,
  requests,
  scipy,
  setuptools,
}:

buildPythonPackage rec {
  pname = "yfinance";
  version = "0.2.58";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ranaroussi";
    repo = "yfinance";
    tag = version;
    hash = "sha256-Xndky4sMVn0sPH4CFdLuwcfhPzMXtH4rdakQdve3RK0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    beautifulsoup4
    cryptography
    curl-cffi
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
    changelog = "https://github.com/ranaroussi/yfinance/blob/${src.tag}/CHANGELOG.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
