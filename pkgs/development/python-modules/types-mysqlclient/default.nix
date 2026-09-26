{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:
let
  version = "2.2.0.20260508";
in
buildPythonPackage {
  inherit version;
  pname = "types-mysqlclient";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "types_mysqlclient";
    hash = "sha256-DrNMz7yF4vf9V3JyNlGtKGPjayeHADO+/ka+crqfz+I=";
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
