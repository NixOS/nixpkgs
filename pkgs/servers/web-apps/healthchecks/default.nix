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
      fido2 = prev.fido2.overridePythonAttrs (old: rec {
        version = "0.9.3";
        src = prev.fetchPypi {
          pname = "fido2";
          inherit version;
          sha256 = "sha256-tF6JphCc/Lfxu1E3dqotZAjpXEgi+DolORi5RAg0Zuw=";
        };
      });
    };
  };
in
py.pkgs.buildPythonApplication rec {
  pname = "healthchecks";
  version = "2.2.1";
  format = "other";

  src = fetchFromGitHub {
    owner = "healthchecks";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-C+NUvs5ijbj/l8G1sjSXvUJDNSOTVFAStfS5KtYFpUs=";
  };

  propagatedBuildInputs = with py.pkgs; [
    apprise
    cffi
    cron-descriptor
    cronsim
    cryptography
    django
    django-compressor
    fido2
    minio
    psycopg2
    py
    pyotp
    requests
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
    EMAIL_HOST_PASSWORD_FILE = os.getenv("EMAIL_HOST_PASSWORD_FILE")
    if EMAIL_HOST_PASSWORD_FILE:
        with open(EMAIL_HOST_PASSWORD_FILE, "r") as file:
            EMAIL_HOST_PASSWORD = file.readline()
  '';

  # Thanks to linuxserver.io for this code block: https://github.com/linuxserver/docker-healthchecks/blob/master/root/etc/cont-init.d/30-config#L116
  createSuperuser = writeText "create_superuser.py" ''
    from django.contrib.auth.models import User;
    from hc.accounts.views import _make_user;
    import os
    SUPERUSER_EMAIL = os.getenv("SUPERUSER_EMAIL")
    SUPERUSER_PASSWORD_FILE = os.getenv("SUPERUSER_PASSWORD_FILE")
    if SUPERUSER_PASSWORD_FILE:
        with open(SUPERUSER_PASSWORD_FILE, "r") as file:
            SUPERUSER_PASSWORD = file.readline()
    if SUPERUSER_EMAIL and SUPERUSER_PASSWORD:
        if User.objects.filter(email=SUPERUSER_EMAIL).count()==0:
            user = _make_user(SUPERUSER_EMAIL);
            user.set_password(SUPERUSER_PASSWORD);
            user.is_staff = True;
            user.is_superuser = True;
            user.save();
            print('Superuser created.');
        else:
            print('Superuser creation skipped. Already exists.');
  '';

  installPhase = ''
    mkdir -p $out/opt/healthchecks
    cp -r . $out/opt/healthchecks
    chmod +x $out/opt/healthchecks/manage.py
    cp ${localSettings} $out/opt/healthchecks/hc/local_settings.py
    cp ${createSuperuser} $out/opt/healthchecks/hc/create_superuser.py
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
