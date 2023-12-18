{ lib
, buildPythonPackage
, fetchPypi
, mock
, oslo-concurrency
, oslo-db
, pbr
, python-dateutil
, stestr
}:

buildPythonPackage rec {
  pname = "subunit2sql";
  version = "1.10.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-c+Dg6moKiv30M0mmwGQSOEbc94gfH//ZnF7lnBgv8EU=";
  };

  propagatedBuildInputs = [
    oslo-db
    pbr
    python-dateutil
  ];

  nativeCheckInputs = [
    mock
    oslo-concurrency
    stestr
  ];

  checkPhase = ''
    export PATH=$out/bin:$PATH
    export HOME=$TMPDIR

    stestr run -e <(echo "
    subunit2sql.tests.db.test_api.TestDatabaseAPI.test_get_failing_test_ids_from_runs_by_key_value
    subunit2sql.tests.db.test_api.TestDatabaseAPI.test_get_id_from_test_id
    subunit2sql.tests.db.test_api.TestDatabaseAPI.test_get_test_run_dict_by_run_meta_key_value
    subunit2sql.tests.migrations.test_migrations.TestWalkMigrations.test_sqlite_opportunistically
    subunit2sql.tests.test_shell.TestMain.test_main
    subunit2sql.tests.test_shell.TestMain.test_main_with_targets
    ")
  '';

  pythonImportsCheck = [ "subunit2sql" ];

  meta = with lib; {
    description = "Command to Read a subunit file or stream and put the data in a SQL DB";
    homepage = "https://opendev.org/opendev/subunit2sql";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
