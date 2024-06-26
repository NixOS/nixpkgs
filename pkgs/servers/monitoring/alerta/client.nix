{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "alerta";
  version = "8.5.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ePvT2icsgv+io5aDDUr1Zhfodm4wlqh/iqXtNkFhS10=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    six
    click
    requests
    requests-hawk
    pytz
    tabulate
  ];

  doCheck = false;

  disabled = python3.pythonOlder "3.6";

  meta = with lib; {
    homepage = "https://alerta.io";
    description = "Alerta Monitoring System command-line interface";
    mainProgram = "alerta";
    license = licenses.asl20;
  };
}
