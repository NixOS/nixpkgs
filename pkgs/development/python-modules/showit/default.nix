{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  numpy,
  matplotlib,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "showit";
  version = "1.1.4";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "freeman-lab";
    repo = "showit";
    rev = "ef76425797c71fbe3795b4302c49ab5be6b0bacb"; # no tags in repo
    hash = "sha256-JrcqfQtSjbbOhr5quHE+QwlKsA6eUpCifLRzTrOOqHU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    matplotlib
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "showit" ];

  meta = {
    description = "Simple and sensible display of images";
    homepage = "https://github.com/freeman-lab/showit";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
