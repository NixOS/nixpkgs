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
  version = "1.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "58cd9c469eced558cd81aa3f484b2924e8897049e06889e8ff2510435b7ef74b";
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
