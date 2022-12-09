{ lib
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "alerta-server";
  version = "8.7.0";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "sha256-EM3owmj+6gFjU0ARaQP3FLYXliGaGCRSaLgkiPwhGdU=";
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
