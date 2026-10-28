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
buildPythonPackage (finalAttrs: {
  pname = "twomemo";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Syndace";
    repo = "python-twomemo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OVZmssJuufKwyEd8q25h9AcDprZZPm588khncBqTaJA=";
  };

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
    changelog = "https://github.com/Syndace/python-twomemo/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    teams = with lib.teams; [ ngi ];
    maintainers = with lib.maintainers; [ themadbit ];
  };
})
