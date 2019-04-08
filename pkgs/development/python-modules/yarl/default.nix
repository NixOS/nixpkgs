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
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "024ecdc12bc02b321bc66b41327f930d1c2c543fa9a561b39861da9388ba7aa9";
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
