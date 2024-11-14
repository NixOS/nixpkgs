{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "terminaltables3";
  version = "4.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Tj7v4gmqiQBaCjTRUlc5QkVpcp7im15kqN1Rxevat38=";
  };

  build-system = [
    poetry-core
  ];

  meta = {
    description = "Display simple tables in terminals";
    homepage = "https://github.com/matthewdeanmartin/terminaltables3";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ itepastra ];
  };
}
