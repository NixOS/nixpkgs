{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pytestCheckHook,
  poetry-core,
  pytest-mock,
}:

buildPythonPackage rec {
  pname = "timelength";
  version = "3.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "EtorixDev";
    repo = "timelength";
    tag = "v${version}";
    hash = "sha256-iaAtDkx6jPPB7s+sTQsrfNFiwerSDZ+7y7C9oNNYEmg=";
  };

  build-system = [
    poetry-core
  ];

  pythonImportsCheck = [ "timelength" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  meta = {
    description = "Flexible python duration parser designed for human readable lengths of time";
    homepage = "https://github.com/EtorixDev/timelength/";
    changelog = "https://github.com/EtorixDev/timelength/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vinetos ];
  };
}
