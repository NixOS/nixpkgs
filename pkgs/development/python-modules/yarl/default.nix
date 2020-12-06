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
  version = "1.6.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8a9066529240171b68893d60dca86a763eae2139dd42f42106b03cf4b426bf10";
  };

  checkInputs = [ pytest pytestrunner ];
  propagatedBuildInputs = [ multidict idna ]
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
