{ lib, python3Packages }:

with lib;

let
  pythonaes = python3Packages.buildPythonPackage rec {
    pname = "pythonaes";
    version = "1.0";
    src = python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "0rwzmwdfslzkabvsxgcg630x27favh1pdwc3dyhcpf006p033pbi";
    };
  };
in python3Packages.buildPythonApplication rec {
  pname = "peepdf";
  version = "0.4.2";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1sblv9dsfvh773qmjpxpzlcxibms6kq2x0rkyh55q8njxh16v1kx";
  };

  postPatch = "sed -i 's/==/>=/' setup.py";

  propagatedBuildInputs =
    with python3Packages; [ jsbeautifier colorama future pillow pythonaes ];

  meta = {
    description = "Powerful Python tool to analyze PDF documents ";
    homepage = https://eternal-todo.com/tools/peepdf-pdf-analysis-tool;
    license = licenses.gpl3;
    maintainers = with maintainers; [ offline ];
  };
}
