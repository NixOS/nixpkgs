{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitLab,
  pythonAtLeast,

  # build-system
  hatchling,
  hatch-requirements-txt,
  hatch-vcs,

  # dependencies
  backports-entry-points-selectable,
  click,
  deprecated,
  python-magic,
  pyyaml,
  requests,
  sentry-sdk,
  tenacity,

  # tests
  aiohttp-utils,
  flask,
  hypothesis,
  iso8601,
  lzip,
  moto,
  msgpack,
  postgresql,
  postgresqlTestHook,
  psycopg,
  pylzma,
  pytestCheckHook,
  pytest-aiohttp,
  pytest-mock,
  pytest-postgresql,
  pytz,
  requests-mock,
  swh-model,
  systemd-python,
  tqdm,
  types-deprecated,
  types-psycopg2,
  types-pytz,
  types-pyyaml,
  types-requests,
  unzip,
  pkgs, # Only for pkgs.zstd
}:

buildPythonPackage (finalAttrs: {
  pname = "swh-core";
  version = "5.0.2";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.softwareheritage.org";
    group = "swh";
    owner = "devel";
    repo = "swh-core";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0k+erTXt/GyJXQN+v5qzlNg+BUl1185MLOZ6U8ySi7U=";
  };

  build-system = [
    hatchling
    hatch-requirements-txt
    hatch-vcs
  ];

  dependencies = [
    backports-entry-points-selectable
    click
    deprecated
    python-magic
    pyyaml
    requests
    sentry-sdk
    tenacity
  ];

  pythonImportsCheck = [ "swh.core" ];

  __darwinAllowLocalNetworking = true;

  # Many broken tests on Darwin. Disabling them for now.
  doCheck = !stdenv.hostPlatform.isDarwin;

  nativeCheckInputs = [
    aiohttp-utils
    flask
    hypothesis
    iso8601
    lzip
    moto
    msgpack
    postgresql
    postgresqlTestHook
    pylzma
    pytestCheckHook
    pytest-aiohttp
    pytest-mock
    pytest-postgresql
    pytz
    requests-mock
    swh-model
    systemd-python
    tqdm
    types-deprecated
    types-psycopg2
    types-pytz
    types-pyyaml
    types-requests
    unzip
    pkgs.zstd
  ]
  ++ psycopg.optional-dependencies.pool;

  disabledTestPaths = lib.optionals (pythonAtLeast "3.14") [
    # shutil.RegistryError: .tar.zst is already registered for "zstdtar"
    "swh/core/tests/test_cli_nar.py"
    "swh/core/tests/test_nar.py"
    "swh/core/tests/test_tarball.py"
    # Most of the tests are failing for different reasons (e.g., it cannot find psql)
    "swh/core/db/tests/test_db_utils.py"
  ];

  disabledTests = [
    # <Result AssertionError("assert {'test': {'cl...23043/tests'}} == {}\n  \n  Left contains 1 more item:\n  \x1b[0m{\x1b[...stgres@127.0.0.1:23043/tests\x1b[39;49;00m\x1b[33m'\x1b[39;49;00m}}\x1b[90m\x1b[39;49;00m\n  Use -v to get more diff")>
    "test_config_file"
    # AssertionError: assert {'backend': {...23043/tests'}} == {'backend': {'cls': 'memory'}}
    "test_config_overload"
    # psql not found
    "test_cli_swh_db_shell"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # FileExistsError: [Errno 17] File exists:
    "test_uncompress_upper_archive_extension"
    # AssertionError: |500 - 632.1152460000121| not within 100
    "test_timed_coroutine"
    "test_timed_start_stop_calls"
    "test_timed"
    "test_timed_no_metric"
  ];

  meta = {
    changelog = "https://gitlab.softwareheritage.org/swh/devel/swh-core/-/tags/${finalAttrs.src.tag}";
    description = "Low-level utilities and helpers used by almost all other modules in the stack";
    homepage = "https://gitlab.softwareheritage.org/swh/devel/swh-core";
    license = lib.licenses.gpl3Only;
    mainProgram = "swh";
    maintainers = with lib.maintainers; [ drupol ];
  };
})
