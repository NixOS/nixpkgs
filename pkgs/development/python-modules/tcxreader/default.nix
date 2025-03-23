{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "tcxreader";
  version = "0.4.11";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "alenrajsp";
    repo = "tcxreader";
    tag = "v${version}";
    hash = "sha256-Iz0VQSukF5CI8lKaxKU4HEmU+n0EbQkuKmduOfsZ/GM=";
  };

  nativeBuildInputs = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "tcxreader" ];

  meta = with lib; {
    description = "Reader for Garmin’s TCX file format";
    homepage = "https://github.com/alenrajsp/tcxreader";
    changelog = "https://github.com/alenrajsp/tcxreader/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ firefly-cpp ];
  };
}
