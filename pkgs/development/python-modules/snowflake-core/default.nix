{
  lib,
  buildPythonPackage,
  pydantic,
  python-dateutil,
  requests,
  snowflake-connector-python,
  pyyaml,
  urllib3,
  fetchPypi,
  pythonOlder,
  hatchling,
}:

buildPythonPackage rec {
  pname = "snowflake-core";
  version = "1.7.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "snowflake_core";
    inherit version;
    hash = "sha256-hlWpTCEa4E0dgD28h2JJ3m0/gCHMVzjWia6oQtG2an8=";
  };

  build-system = [ hatchling ];

  dependencies = [
    pydantic
    python-dateutil
    pyyaml
    requests
    snowflake-connector-python
    urllib3
  ];

  pythonRelaxDeps = [
    "pyopenssl"
  ];

  # Tests require access to Snowflake
  doCheck = false;

  pythonImportsCheck = [
    "snowflake.core"
  ];

  meta = {
    description = "Subpackage providing Python access to Snowflake entity metadata";
    homepage = "https://pypi.org/project/snowflake.core";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.vtimofeenko ];
  };
}
