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
  version = "1.2.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c8cbc21bbfa1dd7d5386d48cc814fe3d35b80f60299cdde9279046f399c3b0d8";
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
