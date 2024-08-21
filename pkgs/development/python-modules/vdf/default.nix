{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "vdf";
  version = "3.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ValvePython";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-6ozglzZZNKDtADkHwxX2Zsnkh6BE8WbcRcC9HkTTgPU=";
  };

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];
  pythonImportsCheck = [ "vdf" ];

  meta = with lib; {
    description = "Library for working with Valve's VDF text format";
    homepage = "https://github.com/ValvePython/vdf";
    license = licenses.mit;
    maintainers = with maintainers; [ kira-bruneau ];
  };
}
