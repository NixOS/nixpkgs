{
  lib,
  agate,
  buildPythonPackage,
  dbt-adapters,
  dbt-common,
  dbt-core,
  dbt-postgres,
  fetchPypi,
  hatchling,
  pytest-mock,
  pytestCheckHook,
  redshift-connector,
  requests,
  sqlparse,
}:

buildPythonPackage rec {
  pname = "dbt-redshift";
  version = "1.11.2";
  pyproject = true;

  # missing tags on GitHub
  src = fetchPypi {
    pname = "dbt_redshift";
    inherit version;
    hash = "sha256-L3qR/vyXHLN6z0dJurcAn/BbQ7sD95O5epDLCXdn/HA=";
  };

  pythonRelaxDeps = [
    "dbt-postgres"
    "redshift-connector"
  ];

  build-system = [ hatchling ];

  dependencies = [
    agate
    dbt-adapters
    dbt-common
    dbt-core
    dbt-postgres
    redshift-connector
    requests
    sqlparse
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  enabledTestPaths = [ "tests/unit" ];

  pytestFlags = [
    # pyproject.toml specifies -n auto which only pytest-xdist understands
    "--override-ini=addopts="
  ];

  disabledTests = [
    # requires network access
    "test_profile_idc_token_all_required_fields"
  ];

  pythonImportsCheck = [ "dbt.adapters.redshift" ];

  meta = {
    description = "Plugin enabling dbt to work with Amazon Redshift";
    homepage = "https://github.com/dbt-labs/dbt-adapters/blob/main/dbt-redshift";
    changelog = "https://github.com/dbt-labs/dbt-adapters/blob/main/dbt-redshift/CHANGELOG.md";
    license = lib.licenses.asl20;
  };
}
