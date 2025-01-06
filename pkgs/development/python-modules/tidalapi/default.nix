{
  lib,
  buildPythonPackage,
  fetchPypi,
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
  version = "0.8.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3I5Xi9vmyAlUNKBmmTuGnetaiiVzL3sEEy31npRZlFU=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    requests
    python-dateutil
    mpegdash
    isodate
    ratelimit
    typing-extensions
  ];

  doCheck = false; # tests require internet access

  pythonImportsCheck = [ "tidalapi" ];

  meta = {
    changelog = "https://github.com/tamland/python-tidal/blob/v${version}/HISTORY.rst";
    description = "Unofficial Python API for TIDAL music streaming service";
    homepage = "https://github.com/tamland/python-tidal";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ drawbu ];
  };
}
