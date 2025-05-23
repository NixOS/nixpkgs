{
  lib,
  asn1crypto,
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
  version = "1.4.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "snowflake_core";
    inherit version;
    hash = "sha256-3BzO3s5BtS/cuF+JwKuAG8Usca5oo79ffp33TXUP5E8=";
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

  preCheck = ''
    export HOME=$(mktemp -d)
  ''; # TODO

  nativeCheckInputs = [ ]; # TODO

  disabledTestPaths = [ ]; # TODO

  disabledTests = [ ]; # TODO

  pythonImportsCheck = [
    "snowflake.core" # TODO
  ];

  meta = with lib; {
    description = "Subpackage providing Python access to Snowflake entity metadata.";
    homepage = "https://pypi.org/project/snowflake.core";
    license = licenses.asl20;
    maintainers = [ maintainers.vtimofeenko ];
  };
}
