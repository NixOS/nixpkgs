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
  sentry-sdk,
  tenacity,
  setuptools,
  setuptools-scm,
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
  version = "4.6.1";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.softwareheritage.org";
    group = "swh";
    owner = "devel";
    repo = "swh-core";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5lL4/Hz8KbWurcDCOHqKh8eNqA1CkliSMCrdeYwqEHs=";
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
    psycopg.optional-dependencies.pool
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
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
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
