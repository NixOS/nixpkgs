{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  requests,
  python-dateutil,
  typing-extensions,
  isodate,
  ratelimit,
  mpegdash,
}:
buildPythonPackage rec {
  pname = "tidalapi";
  version = "0.8.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-60jkJgBTNRMWH9n8mx7gbJeI2+HhEbuOkbmqlgOrOms=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    requests
    python-dateutil
    typing-extensions
    isodate
    ratelimit
    mpegdash
  ];

  pythonImportsCheck = [ "tidalapi" ];

  meta = {
    changelog = "https://github.com/tamland/python-tidal/releases/tag/v${version}";
    description = "Unofficial Python API for TIDAL music streaming service";
    homepage = "https://github.com/tamland/python-tidal";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ drawbu ];
  };
}
