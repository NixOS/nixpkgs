{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  types-markupsafe,
}:

buildPythonPackage rec {
  pname = "types-jinja2";
  version = "2.11.9";
  pyproject = true;

  src = fetchPypi {
    pname = "types-Jinja2";
    inherit version;
    hash = "sha256-29x0pAq6eu1SC35Niejw/kKGUYSUIIs1EjvPCE1LjIE=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    types-markupsafe
  ];

  meta = {
    description = "Typing stubs for Jinja2";
    homepage = "https://pypi.org/project/types-Jinja2/";
    changelog = "https://github.com/typeshed-internal/stub_uploader/blob/main/data/changelogs/MarkupSafe.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
  };
}
