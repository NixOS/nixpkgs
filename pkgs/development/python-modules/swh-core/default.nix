{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitLab,
  backports-entry-points-selectable,
  click,
  deprecated,
  python-magic,
  pyyaml,
  requests,
  sentry-sdk_2,
  tenacity,
  setuptools,
  setuptools-scm,
  flask,
  hypothesis,
  iso8601,
  lzip,
  msgpack,
  psycopg,
  pylzma,
  pytestCheckHook,
  pytest-aiohttp,
  pytest-mock,
  pytest-postgresql,
  pytz,
  requests-mock,
  types-deprecated,
  types-psycopg2,
  types-pytz,
  types-pyyaml,
  types-requests,
  unzip,
  pkgs, # Only for pkgs.zstd
}:

buildPythonPackage rec {
  pname = "swh-core";
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.softwareheritage.org";
    group = "swh";
    owner = "devel";
    repo = "swh-core";
    tag = "v${version}";
    hash = "sha256-kO4B25+oQrQ9sxmKJ5NMKTCCGztRaArFtD7QA8Bytts=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    backports-entry-points-selectable
    click
    deprecated
    python-magic
    pyyaml
    requests
    sentry-sdk_2
    tenacity
  ];

  pythonImportsCheck = [ "swh.core" ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    flask
    hypothesis
    iso8601
    lzip
    msgpack
    psycopg
    pylzma
    pytestCheckHook
    pytest-aiohttp
    pytest-mock
    pytest-postgresql
    pytz
    requests-mock
    types-deprecated
    types-psycopg2
    types-pytz
    types-pyyaml
    types-requests
    unzip
    pkgs.zstd
  ];

  disabledTests =
    [
      # ValueError: Unable to configure handler 'systemd'
      "test_logging_configure_from_yaml"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin) [
      # FileExistsError: [Errno 17] File exists:
      "test_uncompress_upper_archive_extension"
      # AssertionError: |500 - 632.1152460000121| not within 100
      "test_timed_coroutine"
      "test_timed_start_stop_calls"
      "test_timed"
      "test_timed_no_metric"
    ];

  disabledTestPaths = [
    # ModuleNotFoundError: No module named 'aiohttp_utils'
    "swh/core/api/tests/test_async.py"
    "swh/core/api/tests/test_rpc_server_asynchronous.py"
    # ModuleNotFoundError: No module named 'systemd'
    "swh/core/tests/test_logger.py"
    # ModuleNotFoundError: No module named 'psycopg_pool'
    "swh/core/db/tests"
  ];

  meta = {
    description = "Low-level utilities and helpers used by almost all other modules in the stack";
    homepage = "https://gitlab.softwareheritage.org/swh/devel/swh-core";
    license = lib.licenses.gpl3Only;
    mainProgram = "swh";
    maintainers = with lib.maintainers; [ drupol ];
  };
}
