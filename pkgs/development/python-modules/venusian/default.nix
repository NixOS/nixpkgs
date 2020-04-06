{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, pytestcov
}:

buildPythonPackage rec {
  pname = "venusian";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f6842b7242b1039c0c28f6feef29016e7e7dd3caaeb476a193acf737db31ee38";
  };

  checkInputs = [ pytest pytestcov ];

  checkPhase = ''
    pytest
  '';

  meta = with stdenv.lib; {
    description = "A library for deferring decorator actions";
    homepage = https://pylonsproject.org/;
    license = licenses.bsd0;
    maintainers = with maintainers; [ domenkozar ];
  };
}
