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
  swh-perfecthash,
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
  systemd,
  types-python-dateutil,
  types-pyyaml,
  types-requests,
  util-linux,
}:

buildPythonPackage rec {
  pname = "swh-objstorage";
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.softwareheritage.org";
    group = "swh";
    owner = "devel";
    repo = "swh-objstorage";
    tag = "v${version}";
    hash = "sha256-c0ZH2PMT9DVnpTV5PDyX0Yw4iHiJSolEgq/bMXEwXG8=";
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
    swh-perfecthash
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
    systemd
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
    description = "Content-addressable object storage for the Software Heritage project";
    homepage = "https://gitlab.softwareheritage.org/swh/devel/swh-objstorage";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ];
  };
}
