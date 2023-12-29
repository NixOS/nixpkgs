{ lib
, python3
, fetchPypi
}:

python3.pkgs.buildPythonApplication rec {
  pname = "alerta";
  version = "8.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-5KLR+F5GtNkFXJMctJ5F4OvkQRhohd6SWB2ZFVtc/0s=";
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
