{ buildPythonPackage, fetchFromGitHub, lib, pythonOlder, pytest }:
buildPythonPackage rec {
  pname = "typed-ast";
  version = "1.4.3";
  src = fetchFromGitHub {
    owner = "python";
    repo = "typed_ast";
    rev = version;
    sha256 = "16mn9snwik5n2ib65sw2xcaqdm02j8ps21zgjxf8kyy7qnx2mx4w";
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
