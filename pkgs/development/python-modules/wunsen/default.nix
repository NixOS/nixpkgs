{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  pythonOlder,

  unittestCheckHook,

  hatchling,

  khanaa,
}:

buildPythonPackage rec {
  pname = "wunsen";
  version = "0.0.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cakimpei";
    repo = "wunsen";
    rev = "refs/tags/v${version}";
    hash = "sha256-lMEhtcWG+S3vAz+Y/qDxhaZslsO0pbs5xUn5QgZNs2U=";
  };

  build-system = [ hatchling ];

  dependencies = [ khanaa ];

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [
    "-s"
    "tests"
  ];

  pythonImportsCheck = [ "wunsen" ];

  meta = with lib; {
    description = "Transliterate/transcribe other languages into Thai Topics";
    homepage = "https://github.com/cakimpei/wunsen";
    changelog = "https://github.com/cakimpei/wunsen/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ vizid ];
  };
}
