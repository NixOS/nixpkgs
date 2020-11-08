{ stdenv
, lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, multidict
, pytestrunner
, pytest
, typing-extensions
, idna
}:

buildPythonPackage rec {
  pname = "yarl";
  version = "1.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c22c75b5f394f3d47105045ea551e08a3e804dc7e01b37800ca35b58f856c3d6";
  };

  checkInputs = [ pytest pytestrunner ];
  requiredPythonModules = [ multidict idna ]
    ++ lib.optionals (pythonOlder "3.8") [
      typing-extensions
    ];

  meta = with stdenv.lib; {
    description = "Yet another URL library";
    homepage = "https://github.com/aio-libs/yarl/";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
