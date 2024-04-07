{ lib
, python3
, fetchFromGitHub
, fetchYarnDeps
, zlib
, nixosTests
, postgresqlTestHook
, postgresql
, yarn
, fixup_yarn_lock
, nodejs
, fetchpatch
, server-mode ? true
}:

let
  pname = "pgadmin";
  version = "7.7";
  yarnHash = "sha256-8EbbyZHodrYz4a2IYuIWYGutqvrjauSv34o9KFvR/6c=";

  src = fetchFromGitHub {
    owner = "pgadmin-org";
    repo = "pgadmin4";
    rev = "REL-${lib.versions.major version}_${lib.versions.minor version}";
    hash = "sha256-+KD05hzghNFpuw2xW3NUVyKwspCUO9fyJgMPzYk1Xt8=";
  };

  # keep the scope, as it is used throughout the derivation and tests
  # this also makes potential future overrides easier
  pythonPackages = python3.pkgs.overrideScope (final: prev: rec {
    # pgadmin 7.8 is incompatible with Flask >= 2.3
    flask = prev.flask.overridePythonAttrs (oldAttrs: rec {
      version = "2.2.5";
      src = oldAttrs.src.override {
        pname = "Flask";
        inherit version;
        hash = "sha256-7e6bCn/yZiG9WowQ/0hK4oc3okENmbC7mmhQx/uXeqA=";
      };
      format = "setuptools";
    });
    # downgrade needed for older Flask
    httpbin = prev.httpbin.overridePythonAttrs (oldAttrs: rec {
      version = "0.7.0";
      src = oldAttrs.src.override {
        inherit version;
        hash = "sha256-y7N3kMkVdfTxV1f0KtQdn3KesifV7b6J5OwXVIbbjfo=";
      };
      format = "setuptools";
      patches = [
        (fetchpatch {
          # Replaces BaseResponse class with Response class for Werkezug 2.1.0 compatibility
          # https://github.com/postmanlabs/httpbin/pull/674
          url = "https://github.com/postmanlabs/httpbin/commit/5cc81ce87a3c447a127e4a1a707faf9f3b1c9b6b.patch";
          hash = "sha256-SbEWjiqayMFYrbgAPZtSsXqSyCDUz3z127XgcKOcrkE=";
        })
      ];
      pytestFlagsArray = [
        "test_httpbin.py"
      ];
      propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [ final.pythonPackages.brotlipy ];
    });
    # downgrade needed for older httpbin
    werkzeug = prev.werkzeug.overridePythonAttrs (oldAttrs: rec {
      version = "2.2.3";
      format = "setuptools";
      src = oldAttrs.src.override {
        pname = "Werkzeug";
        inherit version;
        hash = "sha256-LhzMlBfU2jWLnebxdOOsCUOR6h1PvvLWZ4ZdgZ39Cv4=";
      };
    });
    # Downgrade needed for older Flask
    flask-security-too = prev.flask-security-too.overridePythonAttrs (oldAttrs: rec {
      version = "5.1.2";
      src = oldAttrs.src.override {
        inherit version;
        hash = "sha256-lZzm43m30y+2qjxNddFEeg9HDlQP9afq5VtuR25zaLc=";
      };
      postPatch = ''
        # This should be removed after updating to version 5.3.0.
        sed -i '/filterwarnings =/a ignore:pkg_resources is deprecated:DeprecationWarning' pytest.ini
      '';
    });
  });

  offlineCache = fetchYarnDeps {
    yarnLock = ./yarn.lock;
    hash = yarnHash;
  };

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
    (fetchpatch {
      name = "CVE-2024-2044.patch";
      url = "https://github.com/pgadmin-org/pgadmin4/commit/4e49d752fba72953acceeb7f4aa2e6e32d25853d.patch";
      hash = "sha256-uIOWefMjbequVfS6haJeSbXv/I6ZdA7uCEwCZSnCtRM=";
      excludes = [ "docs/en_US/release_notes_8_4.rst" ];
    })
    ./CVE-2024-3116.patch
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
    #TODO: Can be removed once boto3>=1.28.0 and cryptography>=41 has been merged to master
    substituteInPlace requirements.txt \
      --replace "boto3>=1.28.*" "boto3>=1.26.*"
    substituteInPlace requirements.txt \
      --replace "botocore>=1.31.*" "botocore>=1.29.*"
    substituteInPlace requirements.txt \
      --replace "cryptography>=41.0.*" "cryptography>=40.0.*"
    # fix extra_require error with "*" in match
    sed 's|*|0|g' -i requirements.txt
    substituteInPlace pkg/pip/setup_pip.py \
      --replace "req = req.replace('psycopg[c]', 'psycopg[binary]')" "req = req"
    ${lib.optionalString (!server-mode) ''
    substituteInPlace web/config.py \
      --replace "SERVER_MODE = True" "SERVER_MODE = False"
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
    fixup_yarn_lock yarn.lock
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

  nativeBuildInputs = with pythonPackages; [ cython pip sphinx yarn fixup_yarn_lock nodejs ];
  buildInputs = [
    zlib
    pythonPackages.wheel
  ];

  propagatedBuildInputs = with pythonPackages; [
    flask
    flask-gravatar
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
    google-auth-oauthlib
    google-api-python-client
    keyring
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
