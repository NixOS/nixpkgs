{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  setuptools,
  setuptools-scm,
  backports-entry-points-selectable,
  cassandra-driver,
  click,
  deprecated,
  flask,
  iso8601,
  mypy-extensions,
  psycopg,
  redis,
  tenacity,
  swh-core,
  swh-model,
  swh-objstorage,
  postgresql,
  postgresqlTestHook,
  pytest-aiohttp,
  pytest-mock,
  pytest-postgresql,
  pytest-shared-session-scope,
  pytest-xdist,
  pytestCheckHook,
  swh-journal,
}:

buildPythonPackage rec {
  pname = "swh-storage";
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.softwareheritage.org";
    group = "swh";
    owner = "devel";
    repo = "swh-storage";
    tag = "v${version}";
    hash = "sha256-Bxwc8OccmqadLjHtmhToHBYHGkD7Fw3Cl3go9VLV/Bs=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    backports-entry-points-selectable
    cassandra-driver
    click
    deprecated
    flask
    iso8601
    mypy-extensions
    psycopg
    redis
    tenacity
    swh-core
    swh-model
    swh-objstorage
  ]
  ++ psycopg.optional-dependencies.pool;

  pythonImportsCheck = [ "swh.storage" ];

  nativeCheckInputs = [
    postgresql
    postgresqlTestHook
    pytest-aiohttp
    pytest-mock
    pytest-postgresql
    pytest-shared-session-scope
    pytest-xdist
    pytestCheckHook
    swh-journal
  ];

  disabledTestPaths = [
    # E       fixture 'redisdb' not found
    "swh/storage/tests/test_replay.py"
    # Unable to setup the local Cassandra database
    "swh/storage/tests/test_cassandra.py"
    "swh/storage/tests/test_cassandra_converters.py"
    "swh/storage/tests/test_cassandra_diagram.py"
    "swh/storage/tests/test_cassandra_migration.py"
    "swh/storage/tests/test_cassandra_ttl.py"
    "swh/storage/tests/test_cli_cassandra.py"
    # Failing tests
    "swh/storage/tests/test_cli_object_references.py"
  ];

  meta = {
    description = "Abstraction layer over the archive, allowing to access all stored source code artifacts as well as their metadata";
    homepage = "https://gitlab.softwareheritage.org/swh/devel/swh-storage";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ];
  };
}
