{ lib
, python3
, fetchurl
, zlib
, mkYarnModules
, sphinx
, nixosTests
, pkgs
, fetchPypi
, postgresqlTestHook
, postgresql
, server-mode ? true
}:

let
  pname = "pgadmin";
  version = "6.19";

  src = fetchurl {
    url = "https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v${version}/source/pgadmin4-${version}.tar.gz";
    sha256 = "sha256-xHvdqVpNU9ZzTA6Xl2Bv044l6Tbvf4fjqyz4TmS9gmI=";
  };

  yarnDeps = mkYarnModules {
    pname = "${pname}-yarn-deps";
    inherit version;
    packageJSON = ./package.json;
    yarnLock = ./yarn.lock;
    yarnNix = ./yarn.nix;
  };


  # keep the scope, as it is used throughout the derivation and tests
  # this also makes potential future overrides easier
  pythonPackages = python3.pkgs.overrideScope (final: prev: rec {
    # flask-security-too 4.1.5 is incompatible with flask-babel 3.x
    flask-babel = prev.flask-babel.overridePythonAttrs (oldAttrs: rec {
      version = "2.0.0";
      src = fetchPypi {
        inherit pname version;
        sha256 = "f9faf45cdb2e1a32ea2ec14403587d4295108f35017a7821a2b1acb8cfd9257d";
      };
      nativeBuildInputs = [ ];
      format = "setuptools";
      outputs = [ "out" ];
    });
    # flask 2.2 is incompatible with pgadmin 6.18
    # https://redmine.postgresql.org/issues/7651
    flask = prev.flask.overridePythonAttrs (oldAttrs: rec {
      version = "2.1.3";
      src = oldAttrs.src.override {
        inherit version;
        sha256 = "sha256-FZcuUBffBXXD1sCQuhaLbbkCWeYgrI1+qBOjlrrVtss=";
      };
    });
    # flask 2.1.3 is incompatible with flask-sqlalchemy > 3
    flask-sqlalchemy = prev.flask-sqlalchemy.overridePythonAttrs (oldAttrs: rec {
      version = "2.5.1";
      format = "setuptools";
      src = oldAttrs.src.override {
        inherit version;
        hash = "sha256-K9pEtD58rLFdTgX/PMH4vJeTbMRkYjQkECv8LDXpWRI=";
      };
    });
    # pgadmin 6.19 is incompatible with the major flask-security-too update to 5.0.x
    flask-security-too = prev.flask-security-too.overridePythonAttrs (oldAttrs: rec {
      version = "4.1.5";
      src = oldAttrs.src.override {
        inherit version;
        hash = "sha256-98jKcHDv/+mls7QVWeGvGcmoYOGCspxM7w5/2RjJxoM=";
      };
      propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [
        final.pythonPackages.flask_mail
        final.pythonPackages.pyqrcode
      ];
    });
  });

in

pythonPackages.buildPythonApplication rec {
  inherit pname version src;

  # from Dockerfile
  CPPFLAGS = "-DPNG_ARM_NEON_OPT=0";

  format = "setuptools";

  patches = [
    # Expose setup.py for later use
    ./expose-setup.py.patch
    # check for permission of /etc/pgadmin/config_system and don't fail
    ./check-system-config-dir.patch
  ];

  postPatch = ''
    # patching Makefile, so it doesn't try to build sphinx documentation here
    # (will do so later)
    substituteInPlace Makefile \
      --replace 'LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 $(MAKE) -C docs/en_US -f Makefile.sphinx html' "true"

    # fix document which refers a non-existing document and fails
    substituteInPlace docs/en_US/contributions.rst \
      --replace "code_snippets" ""
    patchShebangs .

    # relax dependencies
    sed 's|==|>=|g' -i requirements.txt
    substituteInPlace pkg/pip/setup_pip.py \
      --replace "req = req.replace('psycopg2', 'psycopg2-binary')" "req = req"
    ${lib.optionalString (!server-mode) ''
    substituteInPlace web/config.py \
      --replace "SERVER_MODE = True" "SERVER_MODE = False"
    ''}
  '';

  preBuild = ''
    # Adapted from pkg/pip/build.sh
    echo Creating required directories...
    mkdir -p pip-build/pgadmin4/docs

    # build the documentation
    cd docs/en_US
    sphinx-build -W -b html -d _build/doctrees . _build/html

    # Build the clean tree
    cd ../../web
    cp -r * ../pip-build/pgadmin4
    cd ../docs
    cp -r * ../pip-build/pgadmin4/docs
    for DIR in `ls -d ??_??/`
    do
      if [ -d ''${DIR}_build/html ]; then
          mkdir -p ../pip-build/pgadmin4/docs/''${DIR}_build
          cp -R ''${DIR}_build/html ../pip-build/pgadmin4/docs/''${DIR}_build
      fi
    done
    cd ../

    cp -r ${yarnDeps}/* pip-build/pgadmin4

    echo Creating distro config...
    echo HELP_PATH = \'../../docs/en_US/_build/html/\' > pip-build/pgadmin4/config_distro.py
    echo MINIFY_HTML = False >> pip-build/pgadmin4/config_distro.py

    echo Creating manifest...
    echo recursive-include pgadmin4 \* > pip-build/MANIFEST.in

    echo Building wheel...
    cd pip-build
    # copy non-standard setup.py to local directory
    # so setuptools-build-hook can call it
    cp -v ../pkg/pip/setup_pip.py setup.py
  '';

  nativeBuildInputs = with pythonPackages; [ cython pip sphinx ];
  buildInputs = [
    zlib
    pythonPackages.wheel
  ];

  propagatedBuildInputs = with pythonPackages; [
    flask
    flask-gravatar
    flask-login
    flask_mail
    flask_migrate
    flask-sqlalchemy
    flask-wtf
    flask-compress
    passlib
    pytz
    simplejson
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
    flask-babel
    gssapi
    flask-socketio
    eventlet
    httpagentparser
    user-agents
    wheel
    authlib
    qrcode
    pillow
    pyotp
    botocore
    boto3
    azure-mgmt-subscription
    azure-mgmt-rdbms
    azure-mgmt-resource
    azure-identity
    sphinxcontrib-youtube
    dnspython
    greenlet
    speaklater3
  ];

  passthru.tests = {
    inherit (nixosTests) pgadmin4;
  };

  nativeCheckInputs = [
    postgresqlTestHook
    postgresql
    pythonPackages.testscenarios
    pythonPackages.selenium
  ];

  checkPhase = ''
    runHook preCheck

    ## Setup ##

    # pgadmin needs a home directory to save the configuration
    export HOME=$TMPDIR
    cd pgadmin4

    # set configuration for postgresql test
    # also ensure Server Mode is set to false. If not, the tests will fail, since pgadmin expects read/write permissions
    # in /var/lib/pgadmin and /var/log/pgadmin
    # see https://github.com/pgadmin-org/pgadmin4/blob/fd1c26408bbf154fa455a49ee5c12895933833a3/web/regression/runtests.py#L217-L226
    cp -v regression/test_config.json.in regression/test_config.json
    substituteInPlace regression/test_config.json --replace "localhost" "$PGHOST"
    substituteInPlace regression/runtests.py --replace "builtins.SERVER_MODE = None" "builtins.SERVER_MODE = False"

    ## Browser test ##

    # don't bother to test kerberos authentication
    python regression/runtests.py --pkg browser --exclude browser.tests.test_kerberos_with_mocking

    ## Reverse engineered SQL test ##

    python regression/runtests.py --pkg resql

    runHook postCheck
  '';

  meta = with lib; {
    description = "Administration and development platform for PostgreSQL${optionalString (!server-mode) ". Desktop Mode"}";
    longDescription = ''
      pgAdmin 4 is designed to meet the needs of both novice and experienced Postgres users alike,
      providing a powerful graphical interface that simplifies the creation, maintenance and use of database objects.
      ${if server-mode then ''
      This version is build with SERVER_MODE set to True (the default). It will require access to `/var/lib/pgadmin`
      and `/var/log/pgadmin`. This is the default version for the NixOS module `services.pgadmin`.
      This should NOT be used in combination with the `pgadmin4-desktopmode` package as they will interfere.
      '' else ''
      This version is build with SERVER_MODE set to False. It will require access to `~/.pgadmin/`. This version is suitable
      for single-user deployment or where access to `/var/lib/pgadmin` cannot be granted or the NixOS module cannot be used.
      This should NOT be used in combination with the NixOS module `pgadmin` as they will interfere.
      ''}
    '';
    homepage = "https://www.pgadmin.org/";
    license = licenses.mit;
    changelog = "https://www.pgadmin.org/docs/pgadmin4/latest/release_notes_${lib.versions.major version}_${lib.versions.minor version}.html";
    maintainers = with maintainers; [ gador ];
    mainProgram = "pgadmin4";
  };
}
