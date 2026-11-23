{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:
let
  version = "2.3.0.20261122";
in
buildPythonPackage {
  inherit version;
  pname = "types-mysqlclient";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "types_mysqlclient";
    hash = "sha256-dVW2jTtpEXiAIsQQPcikD7qSZ/Dg8TDr7MKzgm5l1T8=";
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
