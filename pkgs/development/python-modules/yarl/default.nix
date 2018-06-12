{ stdenv
, fetchPypi
, buildPythonPackage
, multidict
, pytestrunner
, pytest
, idna
}:

buildPythonPackage rec {
  pname = "yarl";
  version = "1.2.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dd5da4150a882f5cd26aeec7939f38e4b08b790717b9d696409dba9e18ff3ab6";
  };

  checkInputs = [ pytest pytestrunner ];
  propagatedBuildInputs = [ multidict idna ];

  meta = with stdenv.lib; {
    description = "Yet another URL library";
    homepage = https://github.com/aio-libs/yarl/;
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
