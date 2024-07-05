{ lib
, python3Packages
, fetchPypi
}:

python3Packages.buildPythonApplication rec {
  pname = "gh2md";
  version = "2.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-B7IB1TWfZ0StH2zo/tXfDAaPlgLvr4ciIv7B8EQyp8w=";
  };

  propagatedBuildInputs = with python3Packages; [ six requests python-dateutil ];

  # uses network
  doCheck = false;

  pythonImportsCheck = [ "gh2md" ];

  meta = with lib; {
    description = "Export Github repository issues to markdown files";
    mainProgram = "gh2md";
    homepage = "https://github.com/mattduck/gh2md";
    license = licenses.mit;
    maintainers = with maintainers; [ artturin ];
  };
}
