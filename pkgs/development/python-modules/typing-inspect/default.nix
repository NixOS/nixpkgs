{ lib
, buildPythonPackage
, fetchPypi
, typing-extensions
, mypy-extensions
}:

buildPythonPackage rec {
  pname = "typing-inspect";
  version = "0.6.0";

  src = fetchPypi {
    inherit version;
    pname = "typing_inspect";
    sha256 = "1dzs9a1pr23dhbvmnvms2jv7l7jk26023g5ysf0zvnq8b791s6wg";
  };

  propagatedBuildInputs = [
    typing-extensions
    mypy-extensions
  ];

  meta = with lib; {
    description = "Runtime inspection utilities for Python typing module";
    homepage = "https://github.com/ilevkivskyi/typing_inspect";
    license = licenses.mit;
    maintainers = with maintainers; [ albakham ];
  };
}
