{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "zipfile2";
  version = "0.0.12-unstable-2024-09-28";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "cournape";
    repo = "zipfile2";
    #rev = "refs/tags/v${version}";
    rev = "8823f7253772e5c5811343306a591c00c764c6d0";
    hash = "sha256-jDOyIj0sQS1dIsar4nyk5V2mme3Zc6VTms49/4n93ho=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "zipfile2" ];

  disabledTests = [
    # PermissionError: [Errno 1] Operation not ...
    "test_extract"
  ];

  meta = with lib; {
    description = "Backwards-compatible improved zipfile class";
    homepage = "https://github.com/cournape/zipfile2";
    changelog = "https://github.com/itziakos/zipfile2/releases/tag/v${version}";
    license = licenses.psfl;
    maintainers = with maintainers; [ genericnerdyusername ];
  };
}
