{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  setuptools,
  setuptools-scm,
  confluent-kafka,
  msgpack,
  swh-core,
  swh-model,
  pytestCheckHook,
  pytest-mock,
}:

buildPythonPackage rec {
  pname = "swh-journal";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.softwareheritage.org";
    group = "swh";
    owner = "devel";
    repo = "swh-journal";
    tag = "v${version}";
    hash = "sha256-ycTB7hSjTerJOd+nEv8HbM82vPAO8P1+xooy0oN4eHw=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    confluent-kafka
    msgpack
    swh-core
    swh-model
  ];

  pythonImportsCheck = [ "swh.journal" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  meta = {
    description = "Persistent logger of changes to the archive, with publish-subscribe support";
    homepage = "https://gitlab.softwareheritage.org/swh/devel/swh-journal";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
  };
}
