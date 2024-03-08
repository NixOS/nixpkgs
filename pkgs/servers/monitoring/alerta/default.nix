{ lib
, python3
, fetchPypi
}:

python3.pkgs.buildPythonApplication rec {
  pname = "alerta-server";
  version = "9.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-v4+0l5Sx9RTxmNFnKCoKrWFl1xu1JIRZ/kiI6zi/y0I=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    bcrypt
    blinker
    cryptography
    flask
    flask-compress
    flask-cors
    mohawk
    psycopg2
    pyjwt
    pymongo
    pyparsing
    python-dateutil
    pytz
    pyyaml
    requests
    requests-hawk
    sentry-sdk
    setuptools
  ];

  # We can't run the tests from Nix, because they rely on the presence of a working MongoDB server
  doCheck = false;

  pythonImportsCheck = [
    "alerta"
  ];

  meta = with lib; {
    homepage = "https://alerta.io";
    description = "Alerta Monitoring System server";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
