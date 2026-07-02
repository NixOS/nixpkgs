{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:
let
  version = "2.2.0.20250915";
in
buildPythonPackage {
  inherit version;
  pname = "types-mysqlclient";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "types_mysqlclient";
    hash = "sha256-/nCJOVm6w38Xry/MDKGvoXtxRpg+HGzAM2oTFAzO/I0=";
  };

  build-system = [ setuptools ];

  doCheck = false;

  pythonImportsCheck = [ "MySQLdb-stubs" ];

  meta = {
    description = "Typing stubs for mysqlclient";
    changelog = "https://github.com/typeshed-internal/stub_uploader/blob/main/data/changelogs/mysqlclient.md";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.Nebucatnetzer ];
  };
}
