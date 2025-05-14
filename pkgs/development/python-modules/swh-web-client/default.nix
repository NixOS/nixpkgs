{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  setuptools,
  setuptools-scm,
  click,
  dateutils,
  requests,
  swh-auth,
  swh-core,
  swh-model,
  pytestCheckHook,
  pytest-mock,
  requests-mock,
  types-python-dateutil,
  types-pyyaml,
  types-requests,
}:

buildPythonPackage rec {
  pname = "swh-web-client";
  version = "0.9.0";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.softwareheritage.org";
    group = "swh";
    owner = "devel";
    repo = "swh-web-client";
    tag = "v${version}";
    hash = "sha256-/h3TaEwo2+B89KFpIKi9LH0tlGplsv3y18pC0TKM0jA=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    click
    dateutils
    requests
    swh-auth
    swh-core
    swh-model
  ];

  pythonImportsCheck = [ "swh.web.client" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
    requests-mock
    types-python-dateutil
    types-pyyaml
    types-requests
  ];

  meta = {
    description = "Client for Software Heritage Web applications, via their APIs";
    homepage = "https://gitlab.softwareheritage.org/swh/devel/swh-web-client";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
