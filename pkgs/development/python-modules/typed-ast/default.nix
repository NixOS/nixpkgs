{
  lib,
  buildPythonPackage,
  pythonAtLeast,
  fetchFromGitHub,
  setuptools,
  pytest,
}:

buildPythonPackage rec {
  pname = "typed-ast";
  version = "1.5.5";
  pyproject = true;

  # error: unknown type name ‘PyFutureFeatures’
  disabled = pythonAtLeast "3.13";

  src = fetchFromGitHub {
    owner = "python";
    repo = "typed_ast";
    tag = version;
    hash = "sha256-A/FA6ngu8/bbpKW9coJ7unm9GQezGuDhgBWjOhAxm2o=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [ pytest ];

  preCheck = ''
    rm -rf typed_ast
  '';

  pythonImportsCheck = [
    "typed_ast"
    "typed_ast.ast27"
    "typed_ast.ast3"
    "typed_ast.conversions"
  ];

  meta = {
    description = "Python AST modules with type comment support";
    homepage = "https://github.com/python/typed_ast";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
