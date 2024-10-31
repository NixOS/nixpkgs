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
  version = "0.7.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-X6U34T1sM4P+JFpOfcI7CmULcGZ4SCXwP2fFHKi1cWE=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
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
    changelog = "https://github.com/tamland/python-tidal/releases/tag/v${version}";
    description = "Unofficial Python API for TIDAL music streaming service";
    homepage = "https://github.com/tamland/python-tidal";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ drawbu ];
  };
}
