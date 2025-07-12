{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  doubleratchet,
  omemo,
  x3dh,
  xeddsa,
  protobuf,
  typing-extensions,
  xmlschema,
}:
buildPythonPackage rec {
  pname = "twomemo";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Syndace";
    repo = "python-twomemo";
    tag = "v${version}";
    hash = "sha256-jkazeFdNK0iB76oyHbQu+TLaGz+SH/30CmqXk0K6Sy8=";
  };

  strictDeps = true;

  build-system = [ setuptools ];

  dependencies = [
    doubleratchet
    omemo
    x3dh
    xeddsa
    protobuf
    typing-extensions
  ];

  optional-dependencies.xml = [
    xmlschema
  ];

  pythonImportsCheck = [
    "twomemo"
  ];

  meta = {
    description = "Backend implementation of the urn:xmpp:omemo:2 namespace for python-omemo";
    homepage = "https://github.com/Syndace/python-twomemo";
    changelog = "https://github.com/Syndace/python-twomemo/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    teams = with lib.teams; [ ngi ];
    maintainers = with lib.maintainers; [ themadbit ];
  };
}
