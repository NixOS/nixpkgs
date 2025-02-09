{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonApplication rec {
  pname = "eliot-tree";
  version = "19.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18gvijsm0vh3x83mv8dd80c3mpm80r7i111qsg4y7rj4i590phma";
  };

  nativeCheckInputs = with python3Packages; [
    testtools
    pytest
   ];

  propagatedBuildInputs = with python3Packages; [
    colored
    eliot
    iso8601
    jmespath
    setuptools
    toolz
  ];

  # Tests run eliot-tree in out/bin.
  checkPhase = ''
    export PATH=$out/bin:$PATH
    pytest
  '';

  meta = with lib; {
    homepage = "https://github.com/jonathanj/eliottree";
    description = "Render Eliot logs as an ASCII tree";
    license = licenses.mit;
    maintainers = [ maintainers.dpausp ];
  };
}
