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
  version = "0.9.1";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.softwareheritage.org";
    group = "swh";
    owner = "devel";
    repo = "swh-web-client";
    tag = "v${version}";
    hash = "sha256-JTVu3fCYEDMWAqGwK+0a2AVyJv5DSGfItEss9CbzsRg=";
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
    maintainers = with lib.maintainers; [ ];
  };
}
