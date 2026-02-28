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
  hatchling,
}:

buildPythonPackage rec {
  pname = "snowflake-core";
  version = "1.11.0";
  pyproject = true;

  src = fetchPypi {
    pname = "snowflake_core";
    inherit version;
    hash = "sha256-qNwgnEXUE8P+DrGpOb32R6BapNkWwEJBbeljYYhVU5I=";
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
