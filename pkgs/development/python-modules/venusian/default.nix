{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "venusian";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "64ec8285b80b110d0ae5db4280e90e31848a59db98db1aba4d7d46f48ce91e3e";
  };

  checkInputs = [ pytest ];

  checkPhase = ''
    pytest
  '';

  meta = with stdenv.lib; {
    description = "A library for deferring decorator actions";
    homepage = http://pylonsproject.org/;
    license = licenses.bsd0;
    maintainers = with maintainers; [ domenkozar ];
  };
}
