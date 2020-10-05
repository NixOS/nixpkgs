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
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "61d3ea3c175fe45f1498af868879c6ffeb989d4143ac542163c45538ba5ec21b";
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
