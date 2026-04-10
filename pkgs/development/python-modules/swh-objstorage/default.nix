{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitLab,
  pythonAtLeast,
  util-linux,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
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
  swh-core,
  swh-model,
  swh-shard,
  tenacity,

  # tests
  aiohttp,
  azure-core,
  azure-storage-blob,
  fixtures,
  libcloud,
  postgresql,
  postgresqlTestHook,
  pytest-mock,
  pytest-postgresql,
  pytestCheckHook,
  requests-mock,
  requests-toolbelt,
  systemd-python,
  types-python-dateutil,
  types-pyyaml,
  types-requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "swh-objstorage";
  version = "5.1.0";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.softwareheritage.org";
    group = "swh";
    owner = "devel";
    repo = "swh-objstorage";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NnNT9Lt/LGDIJpUmfkfPn6JnF3k8Usf2UVa88zHPKlg=";
  };

  postPatch = ''
    substituteInPlace swh/objstorage/backends/winery/roshard.py \
      --replace-fail \
        "/usr/bin/fallocate" \
        "${lib.getExe' util-linux "fallocate"}"
  '';

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
    swh-core
    swh-model
    swh-shard
    tenacity
  ];

  pythonImportsCheck = [ "swh.objstorage" ];

  # Many broken tests on Darwin. Disabling them for now.
  doCheck = !stdenv.hostPlatform.isDarwin;

  enabledTestPaths = [ "swh/objstorage/tests" ];

  nativeCheckInputs = [
    aiohttp
    azure-core
    azure-storage-blob
    fixtures
    libcloud
    postgresql
    postgresqlTestHook
    pytest-mock
    pytest-postgresql
    pytestCheckHook
    requests-mock
    requests-toolbelt
    systemd-python
    types-python-dateutil
    types-pyyaml
    types-requests
    util-linux
  ]
  ++ psycopg.optional-dependencies.pool;

  disabledTestPaths = lib.optionals (pythonAtLeast "3.14") [
    # _pickle.PicklingError: Can't pickle local object
    "swh/objstorage/tests/test_objstorage_api.py"
  ];

  disabledTests =
    lib.optionals (pythonAtLeast "3.14") [
      "test_winery_add_and_pack"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
      # FAILED swh/objstorage/tests/test_objstorage_winery.py::test_winery_leaky_bucket_tick - assert 1 == 0
      "test_winery_leaky_bucket_tick"
    ];

  meta = {
    changelog = "https://gitlab.softwareheritage.org/swh/devel/swh-objstorage/-/tags/${finalAttrs.src.tag}";
    description = "Content-addressable object storage for the Software Heritage project";
    homepage = "https://gitlab.softwareheritage.org/swh/devel/swh-objstorage";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ drupol ];
  };
})
