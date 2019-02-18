{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "venusian";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9902e492c71a89a241a18b2f9950bea7e41d025cc8f3af1ea8d8201346f8577d";
  };

  checkInputs = [ pytest ];

  checkPhase = ''
    pytest
  '';

  meta = with stdenv.lib; {
    description = "A library for deferring decorator actions";
    homepage = http://pylonsproject.org/;
    license = licenses.bsd0;
    maintainers = with maintainers; [ garbas domenkozar ];
  };
}
