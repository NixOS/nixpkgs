{ lib
, buildPythonPackage
, fetchPypi
, typing-extensions
, mypy-extensions
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "typing-inspect";
  version = "0.8.0";

  src = fetchPypi {
    inherit version;
    pname = "typing_inspect";
    hash = "sha256-ix/wxACUO2FF34EZxBwkTKggfx8QycBXru0VYOSAbj0=";
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
