{ stdenv
, lib
, python3
, fetchurl
, zlib
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "pgadmin";
  version = "5.4";

  src = fetchurl {
    url = "https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v${version}/source/pgadmin4-${version}.tar.gz";
    sha256 = "N0+fnS0ndH/bqwVMra6kSvKoxRCGPCvLs8aZ0PvWv0o=";
  };

  # from Dockerfile
  CPPFLAGS="-DPNG_ARM_NEON_OPT=0";

  format = "other";

  postPatch = ''
    # sed -r 's|LC_ALL=en_US.UTF-8.* Makefile.sphinx .*$|true|g' -i Makefile
    patchShebangs .
  '';

  buildInputs = [
    zlib
  ];

  propagatedBuildInputs = with python3Packages; [
    flask
    flask-gravatar
    flask_login
    flask_mail
    flask_migrate
    flask_sqlalchemy
    flask_wtf
    flask-compress
    passlib
    pytz
    simplejson
    six
    (lib.hiPrio speaklater3)
    sqlparse
    wtforms
    flask-paranoid
    psutil
    psycopg2
    python-dateutil
    sqlalchemy
    itsdangerous
    flask-security-too
    bcrypt
    cryptography
    sshtunnel
    ldap3
    flask-babelex
    gssapi
    flask-socketio
    eventlet
    httpagentparser
    user-agents
  ];

  meta = with lib; {
    description = "Administration and development platform for PostgreSQL";
    homepage = "https://www.pgadmin.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ mkg20001 ];
  };
}
