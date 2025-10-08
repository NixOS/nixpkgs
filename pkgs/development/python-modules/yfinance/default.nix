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
  protobuf,
  pytz,
  requests-cache,
  requests-ratelimiter,
  requests,
  scipy,
  setuptools,
  websockets,
}:

buildPythonPackage rec {
  pname = "yfinance";
  version = "0.2.66";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ranaroussi";
    repo = "yfinance";
    tag = version;
    hash = "sha256-v8K/mVNnun7ogBixaKAVYwSQgSrnnfvVw40/BeClCKY=";
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
    protobuf
    pytz
    requests
    websockets
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
    maintainers = [ ];
  };
}
