{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, pythonOlder
}:

buildPythonPackage rec {
  pname = "typed-ast";
  version = "1.5.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "python";
    repo = "typed_ast";
    rev = version;
    hash = "sha256-Ul1FIS1a1f8l3tX+m8Bj/LsLQW1sXJv6XzEZ9zh8rfI=";
  };

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

  pythonImportsCheck = [
    "typed_ast"
    "typed_ast.ast27"
    "typed_ast.ast3"
    "typed_ast.conversions"
  ];

  meta = with lib; {
    description = "Python AST modules with type comment support";
    homepage = "https://github.com/python/typed_ast";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
