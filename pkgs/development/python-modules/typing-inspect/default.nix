{ lib
, buildPythonPackage
, fetchPypi
, typing-extensions
, mypy-extensions
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "typing-inspect";
<<<<<<< HEAD
  version = "0.9.0";
=======
  version = "0.8.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchPypi {
    inherit version;
    pname = "typing_inspect";
<<<<<<< HEAD
    hash = "sha256-sj/EL/b272lU5IUsH7USzdGNvqAxNPkfhWqVzMlGH3g=";
=======
    hash = "sha256-ix/wxACUO2FF34EZxBwkTKggfx8QycBXru0VYOSAbj0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
