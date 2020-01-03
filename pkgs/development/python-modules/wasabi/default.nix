{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "wasabi";
  version = "0.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9af48b37709000dac34653be376aaac2e3e15392b8c78d0898124c52e083d088";
  };

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    pytest wasabi/tests
  '';

  meta = with stdenv.lib; {
    description = "A lightweight console printing and formatting toolkit";
    homepage = https://github.com/ines/wasabi;
    license = licenses.mit;
    maintainers = with maintainers; [ danieldk ];
    };
}
