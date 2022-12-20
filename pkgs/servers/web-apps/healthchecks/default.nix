{ lib
, writeText
, fetchFromGitHub
, nixosTests
, python3
}:
let
  py = python3.override {
    packageOverrides = final: prev: {
      django = prev.django_4;
    };
  };
in
py.pkgs.buildPythonApplication rec {
  pname = "healthchecks";
  version = "2.5";
  format = "other";

  src = fetchFromGitHub {
    owner = "healthchecks";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-luwFY1iBtFL+Ye7nP68eIgqlpvMUKnxwdNxkBI7pX/c=";
  };

  propagatedBuildInputs = with py.pkgs; [
    apprise
    cron-descriptor
    cronsim
    django
    django-compressor
    fido2
    minio
    psycopg2
    pycurl
    pyotp
    segno
    statsd
    whitenoise
  ];

  localSettings = writeText "local_settings.py" ''
    import os
    STATIC_ROOT = os.getenv("STATIC_ROOT")
    SECRET_KEY_FILE = os.getenv("SECRET_KEY_FILE")
    if SECRET_KEY_FILE:
        with open(SECRET_KEY_FILE, "r") as file:
            SECRET_KEY = file.readline()
  '';

  installPhase = ''
    mkdir -p $out/opt/healthchecks
    cp -r . $out/opt/healthchecks
    chmod +x $out/opt/healthchecks/manage.py
    cp ${localSettings} $out/opt/healthchecks/hc/local_settings.py
  '';

  passthru = {
    # PYTHONPATH of all dependencies used by the package
    pythonPath = py.pkgs.makePythonPath propagatedBuildInputs;

    tests = {
      inherit (nixosTests) healthchecks;
    };
  };

  meta = with lib; {
    homepage = "https://github.com/healthchecks/healthchecks";
    description = "A cron monitoring tool written in Python & Django ";
    license = licenses.bsd3;
    maintainers = with maintainers; [ phaer ];
  };
}
