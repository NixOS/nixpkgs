{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  setuptools,
  setuptools-scm,
  celery,
  flask,
  humanize,
  importlib-metadata,
  pika,
  psycopg,
  tabulate,
  swh-storage,
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

buildPythonPackage rec {
  pname = "swh-scheduler";
  version = "3.3.0";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.softwareheritage.org";
    group = "swh";
    owner = "devel";
    repo = "swh-scheduler";
    tag = "v${version}";
    hash = "sha256-Kv5QH3sj/InKOSjxGtwVxtoAluHx5eIxO5GqcbOs0NY=";
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
    celery
    flask
    humanize
    importlib-metadata
    pika
    psycopg
    tabulate
    swh-storage
  ];

  pythonImportsCheck = [ "swh.scheduler" ];

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

  disabledTests = [ "test_setup_log_handler_with_env_configuration" ];

  meta = {
    changelog = "https://gitlab.softwareheritage.org/swh/devel/swh-scheduler/-/tags/${src.tag}";
    description = "Job scheduler for the Software Heritage project";
    homepage = "https://gitlab.softwareheritage.org/swh/devel/swh-scheduler";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
  };
}
