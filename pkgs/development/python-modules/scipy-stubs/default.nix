{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  hatchling,
  optype,
  scipy,
}:

buildPythonPackage rec {
  pname = "scipy-stubs";
  version = "1.16.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scipy";
    repo = "scipy-stubs";
    tag = "v${version}";
    hash = "sha256-KRwFQG1Nb+Kh9OpQCGtvUzQA0MHNEZnRlzSkpZCNxuw=";
  };

  disabled = pythonOlder "3.11";

  build-system = [
    hatchling
  ];

  dependencies = [
    optype
  ];

  optional-dependencies = {
    scipy = [
      scipy
    ];
  };

  nativeCheckInputs = [
    scipy
  ];

  meta = {
    description = "Typing Stubs for SciPy";
    homepage = "https://github.com/scipy/scipy-stubs";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jolars ];
  };
}
