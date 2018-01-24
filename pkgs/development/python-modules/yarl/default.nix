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
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "162630v7f98l27h11msk9416lqwm2mpgxh4s636594nlbfs9by3a";
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
