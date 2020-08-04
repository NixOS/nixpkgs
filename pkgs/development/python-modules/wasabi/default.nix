{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "wasabi";
  version = "0.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ee3809f4ce00e1e7f424b1572c753cff0dcaca2ca684e67e31f985033a9f070b";
  };

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    pytest wasabi/tests
  '';

  meta = with stdenv.lib; {
    description = "A lightweight console printing and formatting toolkit";
    homepage = "https://github.com/ines/wasabi";
    license = licenses.mit;
    maintainers = with maintainers; [ danieldk ];
    };
}
