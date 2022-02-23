{ stdenv
, lib
, python3
, fetchurl
, zlib
, mkYarnModules
, sphinx
, nixosTests
}:

let

  pname = "pgadmin";
  version = "6.5";

  src = fetchurl {
    url = "https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v${version}/source/pgadmin4-${version}.tar.gz";
    sha256 = "0df1r7c7vgrkc6qq6ljxsak9ish477508hdxgqqpqiy816inyaa0";
  };

  yarnDeps = mkYarnModules {
    pname = "${pname}-yarn-deps";
    inherit version;
    packageJSON = ./package.json;
    yarnLock = ./yarn.lock;
    yarnNix = ./yarn.nix;
  };
in

python3.pkgs.buildPythonApplication rec {
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
    substituteInPlace Makefile --replace "LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 $(MAKE) -C docs/en_US -f Makefile.sphinx html" "true"
    # fix document which refers a non-existing document and fails
    substituteInPlace docs/en_US/contributions.rst --replace "code_snippets" ""
    patchShebangs .
    # relax dependencies
    substituteInPlace requirements.txt \
      --replace "Pillow==8.3.*" "Pillow>=8.3.0" \
      --replace "psycopg2==2.8.*" "psycopg2>=2.8.0" \
      --replace "cryptography==3.*" "cryptography>=3.0" \
      --replace "requests==2.25.*" "requests>=2.25.0"
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
    ${sphinx}/bin/sphinx-build -W -b html -d _build/doctrees . _build/html

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

  nativeBuildInputs = [ python3 python3.pkgs.cython python3.pkgs.pip ];
  buildInputs = [
    zlib
    python3.pkgs.wheel
  ];

  # tests need an own data, log directory
  # and a working and correctly setup postgres database
  # checks will be run through nixos/tests
  doCheck = false;

  propagatedBuildInputs = with python3.pkgs; [
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
    speaklater3
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
  ];

  passthru = {
    tests = { inherit (nixosTests) pgadmin4 pgadmin4-standalone; };
  };

  meta = with lib; {
    description = "Administration and development platform for PostgreSQL";
    homepage = "https://www.pgadmin.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
  };
}
