{ lib
, python3
, fetchurl
, zlib
, mkYarnModules
, sphinx
, nixosTests
, pkgs
}:

let
  pname = "pgadmin";
  version = "6.15";

  src = fetchurl {
    url = "https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v${version}/source/pgadmin4-${version}.tar.gz";
    sha256 = "sha256-S//Rfi8IiBo+lL0BCFVBw+hy2Tw37B349Gcpq2knqSM=";
  };

  yarnDeps = mkYarnModules {
    pname = "${pname}-yarn-deps";
    inherit version;
    packageJSON = ./package.json;
    yarnLock = ./yarn.lock;
    yarnNix = ./yarn.nix;
  };

  # move buildDeps here to easily pass to test suite
  buildDeps = with pythonPackages; [
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
  ];

  # keep the scope, as it is used throughout the derivation and tests
  # this also makes potential future overrides easier
  pythonPackages = python3.pkgs.overrideScope (final: prev: rec {
    # flask 2.2 is incompatible with pgadmin 6.15
    # https://redmine.postgresql.org/issues/7651
    flask = prev.flask.overridePythonAttrs (oldAttrs: rec {
      version = "2.1.3";
      src = oldAttrs.src.override {
        inherit version;
        sha256 = "sha256-FZcuUBffBXXD1sCQuhaLbbkCWeYgrI1+qBOjlrrVtss=";
      };
    });
    # pgadmin 6.15 is incompatible with the major flask-security-too update to 5.0.x
    flask-security-too = prev.flask-security-too.overridePythonAttrs (oldAttrs: rec {
      version = "4.1.5";
      src = oldAttrs.src.override {
        inherit version;
        sha256 = "sha256-98jKcHDv/+mls7QVWeGvGcmoYOGCspxM7w5/2RjJxoM=";
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
    # don't use Server Mode (can be overridden later)
    substituteInPlace pkg/pip/setup_pip.py \
      --replace "req = req.replace('psycopg2', 'psycopg2-binary')" "req = req" \
      --replace "builtins.SERVER_MODE = None" "builtins.SERVER_MODE = False"
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
          cp -Rv ''${DIR}_build/html ../pip-build/pgadmin4/docs/''${DIR}_build
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

  # tests need an own data, log directory
  # and a working and correctly setup postgres database
  # checks will be run through nixos/tests
  doCheck = false;

  # speaklater3 is seperate because when passing buildDeps
  # to the test, it fails there due to a collision with speaklater
  propagatedBuildInputs = buildDeps ++ [ pythonPackages.speaklater3 ];

  passthru.tests = {
    standalone = nixosTests.pgadmin4-standalone;
    # regression and function tests of the package itself
    package = import ../../../../nixos/tests/pgadmin4.nix { inherit pkgs buildDeps; pythonEnv = pythonPackages; };
  };

  meta = with lib; {
    description = "Administration and development platform for PostgreSQL";
    homepage = "https://www.pgadmin.org/";
    license = licenses.mit;
    changelog = "https://www.pgadmin.org/docs/pgadmin4/latest/release_notes_${lib.versions.major version}_${lib.versions.minor version}.html";
    maintainers = with maintainers; [ gador ];
    mainProgram = "pgadmin4";
  };
}
