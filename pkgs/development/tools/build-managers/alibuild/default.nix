{ lib, python}:

python.pkgs.buildPythonApplication rec {
  pname = "alibuild";
  version = "1.5.5";

  src = python.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "1sh02avpab4qlyin3p928xw91l4fgs8x5x2rzl623ayqsnfjv19j";
  };

  doCheck = false;
  propagatedBuildInputs = [
    python.pkgs.requests
    python.pkgs.pyyaml
  ];

  meta = with lib; {
    homepage = "https://alisw.github.io/alibuild/";
    description = "Build tool for ALICE experiment software";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ktf ];
  };
}
