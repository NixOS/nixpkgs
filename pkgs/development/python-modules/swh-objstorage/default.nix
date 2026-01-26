{
  lib,
  stdenv,
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
  msgpack,
  mypy-extensions,
  psycopg,
  redis,
  tenacity,
  swh-core,
  swh-model,
  swh-shard,
  aiohttp,
  azure-core,
  azure-storage-blob,
  fixtures,
  libcloud,
  postgresql,
  postgresqlTestHook,
  pytestCheckHook,
  pytest-mock,
  pytest-postgresql,
  requests-mock,
  requests-toolbelt,
  systemd-python,
  types-python-dateutil,
  types-pyyaml,
  types-requests,
  util-linux,
}:

buildPythonPackage rec {
  pname = "swh-objstorage";
  version = "5.1.0";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.softwareheritage.org";
    group = "swh";
    owner = "devel";
    repo = "swh-objstorage";
    tag = "v${version}";
    hash = "sha256-NnNT9Lt/LGDIJpUmfkfPn6JnF3k8Usf2UVa88zHPKlg=";
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
    msgpack
    mypy-extensions
    psycopg
    redis
    tenacity
    swh-core
    swh-model
    swh-shard
  ];

  preCheck = ''
    substituteInPlace swh/objstorage/backends/winery/roshard.py \
      --replace-fail "/usr/bin/fallocate" "fallocate"
  '';

  pythonImportsCheck = [ "swh.objstorage" ];

  enabledTestPaths = [ "swh/objstorage/tests" ];

  nativeCheckInputs = [
    aiohttp
    azure-core
    azure-storage-blob
    fixtures
    libcloud
    postgresql
    postgresqlTestHook
    pytestCheckHook
    pytest-mock
    pytest-postgresql
    requests-mock
    requests-toolbelt
    systemd-python
    types-python-dateutil
    types-pyyaml
    types-requests
    util-linux
  ]
  ++ psycopg.optional-dependencies.pool;

  disabledTests = lib.optionals (stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isLinux) [
    # FAILED swh/objstorage/tests/test_objstorage_winery.py::test_winery_leaky_bucket_tick - assert 1 == 0
    "test_winery_leaky_bucket_tick"
  ];

  meta = {
    changelog = "https://gitlab.softwareheritage.org/swh/devel/swh-objstorage/-/tags/${src.tag}";
    description = "Content-addressable object storage for the Software Heritage project";
    homepage = "https://gitlab.softwareheritage.org/swh/devel/swh-objstorage";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
  };
}
