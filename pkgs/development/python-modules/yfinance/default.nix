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

buildPythonPackage (finalAttrs: {
  pname = "yfinance";
  version = "1.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ranaroussi";
    repo = "yfinance";
    tag = finalAttrs.version;
    hash = "sha256-nM6vpxMZmPAw+aNg3U3/zvQ6I8Tzv0gM2IkadexJMC0=";
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

  pythonRelaxDeps = [ "curl_cffi" ];

  optional-dependencies = {
    nospam = [
      requests-cache
      requests-ratelimiter
    ];
    repair = [ scipy ];
  };

  # Tests require internet access
  doCheck = false;

  pythonImportsCheck = [ "yfinance" ];

  meta = {
    description = "Module to doiwnload Yahoo! Finance market data";
    homepage = "https://github.com/ranaroussi/yfinance";
    changelog = "https://github.com/ranaroussi/yfinance/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
