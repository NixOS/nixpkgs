{ lib
, buildPythonPackage
, fetchpatch
, fetchPypi
, mypy-extensions
, pytestCheckHook
, typing-extensions
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "typing-inspect";
  version = "0.6.0";

  src = fetchPypi {
    inherit version;
    pname = "typing_inspect";
    sha256 = "1dzs9a1pr23dhbvmnvms2jv7l7jk26023g5ysf0zvnq8b791s6wg";
  };

  patches = lib.optional (pythonAtLeast "3.9") [
    (fetchpatch {
      name = "fix-for-py39.patch";
      url = "https://github.com/ilevkivskyi/typing_inspect/commit/16919e21936179e53df2f376c8b59b5fc44bd2dd.patch";
      sha256 = "17gvha4z685q04lvy8r0xhddhvqh1bfk1avs5jqbwislpsd83396";
    })
  ];

  propagatedBuildInputs = [
    mypy-extensions
    pytestCheckHook
    typing-extensions
  ];

  pythonImportsCheck = [ "typing_inspect" ];

  meta = with lib; {
    description = "Runtime inspection utilities for Python typing module";
    homepage = "https://github.com/ilevkivskyi/typing_inspect";
    license = licenses.mit;
    maintainers = with maintainers; [ albakham ];
  };
}
