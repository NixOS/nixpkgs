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
  version = "0.9.2";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.softwareheritage.org";
    group = "swh";
    owner = "devel";
    repo = "swh-web-client";
    tag = "v${version}";
    hash = "sha256-ZZptYLC1os2i0NtBD3mp4QaQQRoKxnr9k8gJuqmpizE=";
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
    maintainers = [ ];
  };
}
