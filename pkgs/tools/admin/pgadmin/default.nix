{
  lib,
  python3,
  fetchFromGitHub,
  fetchYarnDeps,
  zlib,
  nixosTests,
  postgresqlTestHook,
  postgresql,
  yarn,
  fixup-yarn-lock,
  nodejs,
  stdenv,
  server-mode ? true,
}:

let
  pname = "pgadmin";
  version = "8.12";
  yarnHash = "sha256-C5CI8oP9vEana3OEs1yAsSSTvO2uLEuCU1nHhC7LerY=";

  src = fetchFromGitHub {
    owner = "pgadmin-org";
    repo = "pgadmin4";
    rev = "REL-${lib.versions.major version}_${lib.versions.minor version}";
    hash = "sha256-OIFHaU+Ty0xJn42iqYhse8dfFJZpx8AV/10RNxp1Y4o=";
  };

  # keep the scope, as it is used throughout the derivation and tests
  # this also makes potential future overrides easier
  pythonPackages = python3.pkgs.overrideScope (final: prev: rec { });

  offlineCache = fetchYarnDeps {
    yarnLock = ./yarn.lock;
    hash = yarnHash;
  };

  # don't bother to test kerberos authentication
  # skip tests on macOS which fail due to an error in keyring, see https://github.com/NixOS/nixpkgs/issues/281214
  skippedTests = builtins.concatStringsSep "," (
    [ "browser.tests.test_kerberos_with_mocking" ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      "browser.server_groups.servers.tests.test_all_server_get"
      "browser.server_groups.servers.tests.test_check_connect"
      "browser.server_groups.servers.tests.test_check_ssh_mock_connect"
      "browser.server_groups.servers.tests.test_is_password_saved"
    ]
  );
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
      --replace-fail 'LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 $(MAKE) -C docs/en_US -f Makefile.sphinx html' "true"

    # fix document which refers a non-existing document and fails
    substituteInPlace docs/en_US/contributions.rst \
      --replace-fail "code_snippets" ""
    # relax dependencies
    sed 's|==|>=|g' -i requirements.txt
    # fix extra_require error with "*" in match
    sed 's|*|0|g' -i requirements.txt
    # remove packageManager from package.json so we can work without corepack
    substituteInPlace web/package.json \
      --replace-fail "\"packageManager\": \"yarn@3.8.3\"" "\"\": \"\""
    substituteInPlace pkg/pip/setup_pip.py \
      --replace-fail "req = req.replace('psycopg[c]', 'psycopg[binary]')" "req = req"
    ${lib.optionalString (!server-mode) ''
      substituteInPlace web/config.py \
        --replace-fail "SERVER_MODE = True" "SERVER_MODE = False"
    ''}
  '';

  preBuild = ''
    # Adapted from pkg/pip/build.sh
    echo Creating required directories...
    mkdir -p pip-build/pgadmin4/docs

    echo Building the documentation
    cd docs/en_US
    sphinx-build -W -b html -d _build/doctrees . _build/html

    # Build the clean tree
    cd ..
    cp -r * ../pip-build/pgadmin4/docs
    for DIR in `ls -d ??_??/`
    do
      if [ -d ''${DIR}_build/html ]; then
          mkdir -p ../pip-build/pgadmin4/docs/''${DIR}_build
          cp -R ''${DIR}_build/html ../pip-build/pgadmin4/docs/''${DIR}_build
      fi
    done
    cd ../

    # mkYarnModules and mkYarnPackage have problems running the webpacker
    echo Building the web frontend...
    cd web
    export HOME="$TMPDIR"
    yarn config --offline set yarn-offline-mirror "${offlineCache}"
    # replace with converted yarn.lock file
    rm yarn.lock
    cp ${./yarn.lock} yarn.lock
    chmod +w yarn.lock
    fixup-yarn-lock yarn.lock
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
    patchShebangs node_modules/
    yarn webpacker
    cp -r * ../pip-build/pgadmin4
    # save some disk space
    rm -rf ../pip-build/pgadmin4/node_modules

    cd ..

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

  nativeBuildInputs = with pythonPackages; [
    cython
    pip
    sphinx
    yarn
    fixup-yarn-lock
    nodejs
  ];
  buildInputs = [
    zlib
    pythonPackages.wheel
  ];

  propagatedBuildInputs = with pythonPackages; [
    flask
    flask-login
    flask-mail
    flask-migrate
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
    psycopg
    python-dateutil
    sqlalchemy
    itsdangerous
    flask-security
    bcrypt
    cryptography
    sshtunnel
    ldap3
    flask-babel
    gssapi
    flask-socketio
    eventlet
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
    google-auth-oauthlib
    google-api-python-client
    keyring
    typer
    rich
    jsonformatter
    libgravatar
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

  # sandboxing issues on aarch64-darwin, see https://github.com/NixOS/nixpkgs/issues/198495
  doCheck = postgresql.doCheck;

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
    substituteInPlace regression/test_config.json --replace-fail "localhost" "$PGHOST"
    substituteInPlace regression/runtests.py --replace-fail "builtins.SERVER_MODE = None" "builtins.SERVER_MODE = False"

    ## Browser test ##
    python regression/runtests.py --pkg browser --exclude ${skippedTests}

    ## Reverse engineered SQL test ##

    python regression/runtests.py --pkg resql

    runHook postCheck
  '';

  meta = {
    description = "Administration and development platform for PostgreSQL${
      lib.optionalString (!server-mode) ". Desktop Mode"
    }";
    longDescription = ''
      pgAdmin 4 is designed to meet the needs of both novice and experienced Postgres users alike,
      providing a powerful graphical interface that simplifies the creation, maintenance and use of database objects.
      ${
        if server-mode then
          ''
            This version is build with SERVER_MODE set to True (the default). It will require access to `/var/lib/pgadmin`
            and `/var/log/pgadmin`. This is the default version for the NixOS module `services.pgadmin`.
            This should NOT be used in combination with the `pgadmin4-desktopmode` package as they will interfere.
          ''
        else
          ''
            This version is build with SERVER_MODE set to False. It will require access to `~/.pgadmin/`. This version is suitable
            for single-user deployment or where access to `/var/lib/pgadmin` cannot be granted or the NixOS module cannot be used (e.g. on MacOS).
            This should NOT be used in combination with the NixOS module `pgadmin` as they will interfere.
          ''
      }
    '';
    homepage = "https://www.pgadmin.org/";
    license = lib.licenses.mit;
    changelog = "https://www.pgadmin.org/docs/pgadmin4/latest/release_notes_${lib.versions.major version}_${lib.versions.minor version}.html";
    maintainers = with lib.maintainers; [ gador ];
    mainProgram = "pgadmin4";
    platforms = lib.platforms.unix;
  };
}
