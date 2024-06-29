{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  pytestCheckHook,
  untokenize,
}:

buildPythonPackage rec {
  pname = "unify";
  version = "0.5";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "myint";
    repo = "unify";
    rev = "refs/tags/v${version}";
    hash = "sha256-cWV/Q+LbeIxnQNqyatRWQUF8X+HHlQdc10y9qJ7v3dA=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ untokenize ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "unify" ];

  disabledTests = [
    # https://github.com/myint/unify/issues/21
    "test_format_code"
    "test_format_code_with_backslash_in_comment"
  ];

  meta = with lib; {
    description = "Modifies strings to all use the same quote where possible";
    mainProgram = "unify";
    homepage = "https://github.com/myint/unify";
    license = licenses.mit;
    maintainers = with maintainers; [ FlorianFranzen ];
  };
}
