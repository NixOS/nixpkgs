{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitLab,

  # Build system
  hatchling,
  hatch-requirements-txt,
  hatch-vcs,

  # Dependencies
  celery,
  dateparser,
  flask,
  humanize,
  importlib-metadata,
  pika,
  psycopg,
  tabulate,
  swh-storage,

  # Tests
  plotille,
  postgresql,
  postgresqlTestHook,
  pytestCheckHook,
  pytest-mock,
  pytest-postgresql,
  pytest-shared-session-scope,
  pytest-xdist,
  requests-mock,
  simpy,
  swh-journal,
  types-python-dateutil,
  types-pyyaml,
  types-requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "swh-scheduler";
  version = "3.6.0";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.softwareheritage.org";
    group = "swh";
    owner = "devel";
    repo = "swh-scheduler";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QcVC/H0La6BMR72GdJg0kDznTbPZChmTlrzqCQwKdDs=";
  };

  build-system = [
    hatchling
    hatch-requirements-txt
    hatch-vcs
  ];

  dependencies = [
    celery
    dateparser
    flask
    humanize
    importlib-metadata
    pika
    psycopg
    tabulate
    swh-storage
  ];

  pythonImportsCheck = [ "swh.scheduler" ];

  # Many broken tests on Darwin. Disabling them for now.
  doCheck = !stdenv.hostPlatform.isDarwin;

  nativeCheckInputs = [
    plotille
    postgresql
    postgresqlTestHook
    pytestCheckHook
    pytest-mock
    pytest-postgresql
    pytest-shared-session-scope
    pytest-xdist
    requests-mock
    simpy
    swh-journal
    types-python-dateutil
    types-pyyaml
    types-requests
  ];

  disabledTests = [
    "test_setup_log_handler_with_env_configuration"
    "test_task_exception"
  ];

  meta = {
    changelog = "https://gitlab.softwareheritage.org/swh/devel/swh-scheduler/-/tags/${finalAttrs.src.tag}";
    description = "Job scheduler for the Software Heritage project";
    homepage = "https://gitlab.softwareheritage.org/swh/devel/swh-scheduler";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ drupol ];
  };
})
