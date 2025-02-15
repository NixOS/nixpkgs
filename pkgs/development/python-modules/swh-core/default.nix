{
  lib,
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
  hypothesis,
  pytest,
  pytest-mock,
  pytest-postgresql,
  pytz,
  requests-mock,
  types-deprecated,
  types-psycopg2,
  types-pytz,
  types-pyyaml,
  types-requests,
}:

buildPythonPackage rec {
  pname = "swh-core";
  version = "3.6.3";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.softwareheritage.org";
    group = "swh";
    owner = "devel";
    repo = "swh-core";
    rev = "refs/tags/v${version}";
    hash = "sha256-OZWmUG7evUmRjRr6Zz60J1+lkFFnkSWMH4sPazADdFw=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonRelaxDeps = [
    # sentry-sdk>=2 not satisfied by version 1.45.0
    "sentry-sdk"
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

  nativeCheckInputs = [
    hypothesis
    pytest
    pytest-mock
    pytest-postgresql
    pytz
    requests-mock
    types-deprecated
    types-psycopg2
    types-pytz
    types-pyyaml
    types-requests
  ];

  meta = {
    description = "Low-level utilities and helpers used by almost all other modules in the stack";
    homepage = "https://gitlab.softwareheritage.org/swh/devel/swh-core";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
