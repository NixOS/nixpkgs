{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  setuptools,
  setuptools-scm,
  requests,
  ndjson,
  flask,
  importlib-metadata,
  swh-core,
  swh-model,
  swh-auth,
  swh-web-client,
  beautifulsoup4,
  pytest,
  pytest-flask,
  pytest-mock,
  types-beautifulsoup4,
  types-pyyaml,
  types-requests,
}:

buildPythonPackage rec {
  pname = "swh-scanner";
  version = "0.8.2";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.softwareheritage.org";
    group = "swh";
    owner = "devel";
    repo = "swh-scanner";
    rev = "refs/tags/v${version}";
    hash = "sha256-mANWiVmlXACFZymtnnBmugkRFHzBaF2lBGIJqCNqlmI=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    requests
    ndjson
    flask
    importlib-metadata
    swh-core
    swh-model
    swh-auth
    swh-web-client
  ];

  pythonImportsCheck = [ "swh.scanner" ];

  nativeCheckInputs = [
    beautifulsoup4
    pytest
    pytest-flask
    pytest-mock
    swh-core
    swh-model
    types-beautifulsoup4
    types-pyyaml
    types-requests
  ];

  meta = {
    description = "Implementation of the Data model of the Software Heritage project, used to archive source code artifacts";
    homepage = "https://gitlab.softwareheritage.org/swh/devel/swh-model";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
