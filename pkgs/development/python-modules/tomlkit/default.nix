{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # tests
  pytestCheckHook,
  pyyaml,

  # passthru.tests
  remarshal,
}:

buildPythonPackage (finalAttrs: {
  pname = "tomlkit";
  version = "0.15.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-poetry";
    repo = "tomlkit";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-6zPz07MdVgXIgmsTK7Sic9cHouP/BR8KAR0dN1hUEjU=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [
    pyyaml
    pytestCheckHook
  ];

  pythonImportsCheck = [ "tomlkit" ];

  passthru.tests = {
    inherit remarshal;
  };

  meta = {
    homepage = "https://github.com/python-poetry/tomlkit";
    changelog = "https://github.com/python-poetry/tomlkit/blob/${finalAttrs.version}/CHANGELOG.md";
    description = "Style-preserving TOML library for Python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dotlambda
      jakewaksbaum
    ];
  };
})
