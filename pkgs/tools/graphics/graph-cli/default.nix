{ lib
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "graph-cli";
  version = "0.1.18";

  src = python3Packages.fetchPypi {
    inherit version;
    pname = "graph_cli";
    sha256 = "sha256-0mxOc8RJ3GNgSbppLylIViqfYf6zwJ49pltnsyQUpSA=";
  };

  propagatedBuildInputs = with python3Packages; [
    numpy
    pandas
    matplotlib
  ];

  # does not contain tests despite reference in Makefile
  doCheck = false;
  pythonImportsCheck = [ "graph_cli" ];

  meta = with lib; {
    description = "CLI to create graphs from CSV files";
    homepage = "https://github.com/mcastorina/graph-cli/";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ leungbk ];
  };
}
