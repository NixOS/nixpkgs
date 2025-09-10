{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python-dateutil,
  poetry-core,
  requests,
  isodate,
  ratelimit,
  typing-extensions,
  mpegdash,
}:
buildPythonPackage rec {
  pname = "tidalapi";
  version = "0.8.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "EbbLabs";
    repo = "python-tidal";
    tag = "v${version}";
    hash = "sha256-SsyO0bh2ayHfGzINBW1BTTPS/ICvIymIhQ1HUPRFOwU=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    requests
    python-dateutil
    mpegdash
    isodate
    ratelimit
    typing-extensions
  ];

  doCheck = false; # tests require internet access

  pythonImportsCheck = [
    "tidalapi"
  ];

  meta = {
    changelog = "https://github.com/tamland/python-tidal/blob/v${version}/HISTORY.rst";
    description = "Unofficial Python API for TIDAL music streaming service";
    homepage = "https://github.com/tamland/python-tidal";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      drawbu
      ryand56
    ];
  };
}
