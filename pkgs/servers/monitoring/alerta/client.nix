{ lib
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "alerta";
  version = "8.4.0";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "260ff3118e73396104129928217b0f317ac5afdff8221874d8986df22ecf5f34";
  };

  propagatedBuildInputs = with python3.pkgs; [
    six click requests requests-hawk pytz tabulate
  ];

  doCheck = false;

  disabled = python3.pythonOlder "3.6";

  meta = with lib; {
    homepage = "https://alerta.io";
    description = "Alerta Monitoring System command-line interface";
    license = licenses.asl20;
  };
}
