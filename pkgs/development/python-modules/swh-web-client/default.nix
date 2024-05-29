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
}:

buildPythonPackage rec {
  pname = "swh-web-client";
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.softwareheritage.org";
    group = "swh";
    owner = "devel";
    repo = "swh-web-client";
    rev = "v${version}";
    hash = "sha256-6/pH0EbUAvyPhgf/5KFqcmFr5CbYSmfOqCKEtcpgTCM=";
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

  meta = {
    description = "Client for Software Heritage Web applications, via their APIs";
    homepage = "https://gitlab.softwareheritage.org/swh/devel/swh-web-client";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
