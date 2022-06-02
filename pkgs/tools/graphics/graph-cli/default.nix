{ lib
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "graph-cli";
  version = "0.1.7";

  src = python3Packages.fetchPypi {
    inherit version;
    pname = "graph_cli";
    sha256 = "sha256-/v9COgAjuunJ06HHl55J0moV1p4uO+N+w2QwE8tgebQ=";
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
