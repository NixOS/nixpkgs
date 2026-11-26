{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-rpm-spec";
  version = "0.18.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bkircher";
    repo = "python-rpm-spec";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k6hVgSF/07a2WvGN9GOokFSuyx5i+5owx1xQdLSQhwI=";
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyrpm.spec" ];

  meta = {
    description = "Python library for parsing RPM spec files";
    homepage = "https://github.com/bkircher/python-rpm-spec";
    changelog = "https://github.com/bkircher/python-rpm-spec/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ peti ];
  };
})
