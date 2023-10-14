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
  version = "2.10";
  format = "other";

  src = fetchFromGitHub {
    owner = "healthchecks";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-1x+pYMHaKgLFWcL1axOv/ok1ebs0I7Q+Q6htncmgJzU=";
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

  secrets = [
    "DB_PASSWORD"
    "DISCORD_CLIENT_SECRET"
    "EMAIL_HOST_PASSWORD"
    "LINENOTIFY_CLIENT_SECRET"
    "MATRIX_ACCESS_TOKEN"
    "PD_APP_ID"
    "PUSHBULLET_CLIENT_SECRET"
    "PUSHOVER_API_TOKEN"
    "S3_SECRET_KEY"
    "SECRET_KEY"
    "SLACK_CLIENT_SECRET"
    "TELEGRAM_TOKEN"
    "TRELLO_APP_KEY"
    "TWILIO_AUTH"
  ];

  localSettings = writeText "local_settings.py" ''
    import os

    STATIC_ROOT = os.getenv("STATIC_ROOT")

    ${lib.concatLines (map
      (secret: ''
        ${secret}_FILE = os.getenv("${secret}_FILE")
        if ${secret}_FILE:
            with open(${secret}_FILE, "r") as file:
                ${secret} = file.readline()
      '')
      secrets)}
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
