{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "wasabi";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qv0zpr6kwjwygx9k8jgafiil5wh2zsyryvbxghzv4yn7jb3xpdq";
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
