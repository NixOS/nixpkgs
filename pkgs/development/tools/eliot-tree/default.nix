{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "eliot-tree";
  version = "21.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-hTl+r+QJPPQ7ss73lty3Wm7DLy2SKGmmgIuJx38ilO8=";
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
    mainProgram = "eliot-tree";
    license = licenses.mit;
    maintainers = [ maintainers.dpausp ];
  };
}
