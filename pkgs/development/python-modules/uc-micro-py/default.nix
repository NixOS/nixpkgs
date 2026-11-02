{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "uc-micro-py";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tsutsu3";
    repo = "uc.micro-py";
    tag = "v${version}";
    hash = "sha256-o4rUK16skeB7+9gvOltYC6u1bIPvw44bVSMoB+BHvRk=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "uc_micro" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Micro subset of unicode data files for linkify-it-py";
    homepage = "https://github.com/tsutsu3/uc.micro-py";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
