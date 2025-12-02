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
  psycopg-pool,
  pyasyncore,
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
  version = "4.1.2";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.softwareheritage.org";
    group = "swh";
    owner = "devel";
    repo = "swh-storage";
    tag = "v${version}";
    hash = "sha256-I6E8l6TWp+XFTo5ZRB3+sbAlpra3U5V4f1OUbD+nKkw=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonRelaxDeps = [
    # we patched click 8.2.1
    "click"
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
    psycopg-pool
    pyasyncore
    redis
    tenacity
    swh-core
    swh-model
    swh-objstorage
  ];

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
    "swh/storage/tests/test_cli_object_references_cassandra.py"
    # Failing tests
    "swh/storage/tests/test_cli_object_references.py"
  ];

  meta = {
    changelog = "https://gitlab.softwareheritage.org/swh/devel/swh-storage/-/tags/${src.tag}";
    description = "Abstraction layer over the archive, allowing to access all stored source code artifacts as well as their metadata";
    homepage = "https://gitlab.softwareheritage.org/swh/devel/swh-storage";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
  };
}
