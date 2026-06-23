{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "tcxreader";
  version = "0.4.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alenrajsp";
    repo = "tcxreader";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Iz0VQSukF5CI8lKaxKU4HEmU+n0EbQkuKmduOfsZ/GM=";
  };

  nativeBuildInputs = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "tcxreader" ];

  meta = {
    description = "Reader for Garmin’s TCX file format";
    homepage = "https://github.com/alenrajsp/tcxreader";
    changelog = "https://github.com/alenrajsp/tcxreader/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ firefly-cpp ];
  };
})
