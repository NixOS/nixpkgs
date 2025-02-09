{ lib
, buildPythonPackage
, fetchPypi
, typing-extensions
, mypy-extensions
, pytestCheckHook
}:

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
    typing-extensions
    mypy-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # https://github.com/ilevkivskyi/typing_inspect/issues/84
    "test_typed_dict_typing_extension"
  ];

  pythonImportsCheck = [
    "typing_inspect"
  ];

  meta = with lib; {
    description = "Runtime inspection utilities for Python typing module";
    homepage = "https://github.com/ilevkivskyi/typing_inspect";
    license = licenses.mit;
    maintainers = with maintainers; [ albakham ];
  };
}
