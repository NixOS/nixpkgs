{
  lib,
  buildPythonPackage,
<<<<<<< HEAD
  fetchFromGitHub,
  setuptools,
=======
  fetchPypi,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  typing-extensions,
  mypy-extensions,
  pytestCheckHook,
}:

<<<<<<< HEAD
buildPythonPackage {
  pname = "typing-inspect";
  version = "0.9.0-unstable-2025-10-20";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ilevkivskyi";
    repo = "typing_inspect";
    rev = "58c98c084ebeb45ee51935506ed1cc3449105fa9";
    hash = "sha256-uGGtV32TGckoM3JALNu2OjIE+gmzJc7VMJlQeKJVFd8=";
  };

  build-system = [ setuptools ];

  dependencies = [
=======
buildPythonPackage rec {
  pname = "typing-inspect";
  version = "0.9.0";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "typing_inspect";
    hash = "sha256-sj/EL/b272lU5IUsH7USzdGNvqAxNPkfhWqVzMlGH3g=";
  };

  propagatedBuildInputs = [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    typing-extensions
    mypy-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

<<<<<<< HEAD
  pythonImportsCheck = [ "typing_inspect" ];

  meta = {
    description = "Runtime inspection utilities for Python typing module";
    homepage = "https://github.com/ilevkivskyi/typing_inspect";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ albakham ];
=======
  disabledTests = [
    # https://github.com/ilevkivskyi/typing_inspect/issues/84
    "test_typed_dict_typing_extension"
  ];

  pythonImportsCheck = [ "typing_inspect" ];

  meta = with lib; {
    description = "Runtime inspection utilities for Python typing module";
    homepage = "https://github.com/ilevkivskyi/typing_inspect";
    license = licenses.mit;
    maintainers = with maintainers; [ albakham ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
