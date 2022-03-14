{ lib
, buildPythonPackage
, fetchPypi
, typing-extensions
, mypy-extensions
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "typing-inspect";
  version = "0.7.1";

  src = fetchPypi {
    inherit version;
    pname = "typing_inspect";
    sha256 = "1al2lyi3r189r5xgw90shbxvd88ic4si9w7n3d9lczxiv6bl0z84";
  };

  propagatedBuildInputs = [
    typing-extensions
    mypy-extensions
  ];

  checkInputs = [
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
