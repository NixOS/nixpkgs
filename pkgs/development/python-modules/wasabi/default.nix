{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "wasabi";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0f18x27qrr29rgxyiy1k9b469i37n80h0x9vd9i22pyg8wxx67q5";
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
