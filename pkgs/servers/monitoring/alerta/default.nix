{ lib
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "alerta-server";
  version = "8.3.3";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "a2713a31c6e326c774a3ee0328f424f944b951935ff1b893a4a66598d61c5a97";
  };

  propagatedBuildInputs = with python3.pkgs; [
    bcrypt
    blinker
    flask
    flask-compress
    flask-cors
    mohawk
    psycopg2
    pyjwt
    pymongo
    python-dateutil
    pytz
    pyyaml
    requests
    requests-hawk
    sentry-sdk
  ];

  doCheck = false; # We can't run the tests from Nix, because they rely on the presence of a working MongoDB server

  disabled = python3.pythonOlder "3.6";

  meta = with lib; {
    homepage = "https://alerta.io";
    description = "Alerta Monitoring System server";
    license = licenses.asl20;
  };
}
