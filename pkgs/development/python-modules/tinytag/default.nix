{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  flit-core,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "tinytag";
  version = "2.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tinytag";
    repo = "tinytag";
    tag = finalAttrs.version;
    hash = "sha256-WrUpP2ItXUYsX5IB5K0YmG/N2mbAeaso6i0uUXkWHlY=";
  };

  build-system = [
    setuptools
    flit-core
  ];

  pythonImportsCheck = [ "tinytag" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Read audio file metadata";
    homepage = "https://github.com/tinytag/tinytag";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
})
