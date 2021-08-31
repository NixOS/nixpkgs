{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, multidict
, pytest-runner
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

  checkInputs = [ pytest pytest-runner ];
  propagatedBuildInputs = [ multidict idna ]
    ++ lib.optionals (pythonOlder "3.8") [
      typing-extensions
    ];

  meta = with lib; {
    description = "Yet another URL library";
    homepage = "https://github.com/aio-libs/yarl/";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
