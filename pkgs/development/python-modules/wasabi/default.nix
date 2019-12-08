{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "wasabi";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0w2jkgrf0x58v8x90v4nifbwcb87pp613vp3sld1fk2avn80imnw";
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
