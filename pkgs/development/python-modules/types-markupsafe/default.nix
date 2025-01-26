{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-markupsafe";
  version = "1.1.10";
  pyproject = true;

  src = fetchPypi {
    pname = "types-MarkupSafe";
    inherit version;
    hash = "sha256-hbOocmg9Aq6jpawqjvWQGTw0QJIDL1hFcof7+OBnEbE=";
  };

  build-system = [
    setuptools
  ];

  meta = {
    description = "Typing stubs for MarkupSafe";
    homepage = "https://pypi.org/project/types-markupsafe";
    changelog = "https://github.com/typeshed-internal/stub_uploader/blob/main/data/changelogs/MarkupSafe.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
  };
}
