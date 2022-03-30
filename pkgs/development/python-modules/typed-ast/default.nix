{ buildPythonPackage, fetchFromGitHub, lib, pythonOlder, pytest }:
buildPythonPackage rec {
  pname = "typed-ast";
  version = "1.5.0";
  src = fetchFromGitHub {
    owner = "python";
    repo = "typed_ast";
    rev = version;
    sha256 = "sha256-z3l5gMG1Jp6EI7SnGn5ABVXVBi+bK///iJBqEWn4d+s=";
  };
  # Only works with Python 3.3 and newer;
  disabled = pythonOlder "3.3";

  pythonImportsCheck = [
    "typed_ast"
    "typed_ast.ast27"
    "typed_ast.ast3"
    "typed_ast.conversions"
  ];

  checkInputs = [
    pytest
  ];
  checkPhase = ''
    runHook preCheck

    # We can't use pytestCheckHook because that invokes pytest with python -m pytest
    # which adds the current directory to sys.path at the beginning.
    # _That_ version of the typed_ast module doesn't have the C extensions we need.
    pytest

    runHook postCheck
  '';

  meta = {
    homepage = "https://github.com/python/typed_ast";
    description = "Python 2 and 3 ast modules with type comment support";
    license = lib.licenses.asl20;
  };
}
