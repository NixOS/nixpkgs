{ lib
, fetchFromGitHub
, makeWrapper
, python3
, callPackage
, antlr4_9
, nixosTests
}:

let
  python = python3.override {
    self = python;
    packageOverrides = self: super: {
      antlr4-python3-runtime = super.antlr4-python3-runtime.override {
        antlr4 = antlr4_9;
      };

      baserow_premium = self.buildPythonPackage rec {
        pname = "baserow_premium";
        version = "1.17.2";
        foramt = "setuptools";

        src = fetchFromGitHub {
          owner = "bram2w";
          repo = pname;
          rev = "refs/tags/${version}";
          hash = "sha256-eU//9iO8Eng+CcG6RlDediBHYI5EyHgGkN96Q7ZDnvI=";
        };

        sourceRoot = "${src.name}/premium/backend";

        # https://gitlab.com/baserow/baserow/-/issues/1716
        postPatch = ''
          echo "fixing config package"
          touch src/baserow_premium/config/__init__.py
          touch src/baserow_premium/config/settings/__init__.py
        '';

        doCheck = false;
      };

      django = super.django_3;

      baserow_enterprise = self.buildPythonPackage rec {
        pname = "baserow_enterprise";
        version = "1.17.2";
        foramt = "setuptools";

        src = fetchFromGitHub {
          owner = "bram2w";
          repo = pname;
          rev = "refs/tags/${version}";
          hash = "sha256-eU//9iO8Eng+CcG6RlDediBHYI5EyHgGkN96Q7ZDnvI=";
        };

        sourceRoot = "source/enterprise/backend";

        # https://gitlab.com/baserow/baserow/-/issues/1716
        postPatch = ''
          echo "fixing missing __init__.py"
          touch src/baserow_enterprise/config/__init__.py
          touch src/baserow_enterprise/config/settings/__init__.py
          touch src/baserow_enterprise/api/teams/__init__.py
          touch src/baserow_enterprise/api/sso/__init__.py
          touch src/baserow_enterprise/api/sso/oauth2/__init__.py
          touch src/baserow_enterprise/api/sso/saml/__init__.py
          touch src/baserow_enterprise/api/admin/__init__.py
          touch src/baserow_enterprise/api/admin/auth_provider/__init__.py
          touch src/baserow_enterprise/auth_provider/__init__.py
          touch src/baserow_enterprise/sso/__init__.py
          touch src/baserow_enterprise/sso/oauth2/__init__.py
          touch src/baserow_enterprise/sso/saml/__init__.py
        '';


        doCheck = false;
      };

    };
  };
in

with python.pkgs; buildPythonApplication rec {
  pname = "baserow";
  version = "1.17.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "bram2w";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-eU//9iO8Eng+CcG6RlDediBHYI5EyHgGkN96Q7ZDnvI=";
  };

  sourceRoot = "${src.name}/backend";

  postPatch = ''
<<<<<<< HEAD
=======
<<<<<<< HEAD
>>>>>>> d93a2b7f43ab (baserow package)
    # use input files to not depend on outdated peer dependencies
    mv requirements/base.{in,txt}
    mv requirements/dev.{in,txt}

    # remove dependency constraints
    sed -i requirements/base.txt \
      -e 's/[~<>=].*//' -i requirements/base.txt \
      -e 's/zope-interface/zope.interface/' \
      -e 's/\[standard\]//'
<<<<<<< HEAD
=======
=======
    echo "fixing missing __init__.py"
    touch src/baserow/contrib/builder/domains/__init__.py
    touch src/baserow/contrib/builder/pages/__init__.py
    touch src/baserow/compat/api/trash/__init__.py
    # remove dependency constraints
    sed 's/[~<>=].*//' -i requirements/base.in requirements/base.txt
    sed 's/zope-interface/zope.interface/' -i requirements/base.in requirements/base.txt
    sed 's/\[standard\]//' -i requirements/base.in requirements/base.txt
    # This variable do not support `redis+socket://`, let's separate all of them.
    # https://gitlab.com/baserow/baserow/-/issues/1715
    sed 's/CELERY_REDBEAT_REDIS_URL = REDIS_URL/CELERY_REDBEAT_REDIS_URL = os.getenv("REDIS_BEAT_URL", REDIS_URL)/' -i src/baserow/config/settings/base.py
    sed 's/\"LOCATION\": REDIS_URL/\"LOCATION\": os.getenv("DJANGO_REDIS_URL", REDIS_URL)/' -i src/baserow/config/settings/base.py
    sed 's/\"hosts\": \[REDIS_URL\]/\"hosts\": \[os.getenv("DJANGO_CHANNEL_REDIS_URL", REDIS_URL)\]/' -i src/baserow/config/settings/base.py
>>>>>>> 636805f104e1 (baserow,baserow-frontend: 1.14.0 -> 1.17.2)
>>>>>>> d93a2b7f43ab (baserow package)
  '';

  nativeBuildInputs = [
    makeWrapper
  ];

  propagatedBuildInputs = [
    google-api-core
    google-cloud-core
    google-cloud-storage
    google-crc32c
    google-resumable-media
    azure-core
    azure-storage-blob
    isodate
    baserow_premium
    baserow_enterprise
>>>>>>> 636805f104e1 (baserow,baserow-frontend: 1.14.0 -> 1.17.2)
    autobahn
    brotli
    decorator
    validators
    requests-oauthlib
    pysaml2
>>>>>>> d93a2b7f43ab (baserow package)
    advocate
    antlr4-python3-runtime
    boto3
    cached-property
    celery-redbeat
<<<<<<< HEAD
=======
    celery-singleton
>>>>>>> d93a2b7f43ab (baserow package)
    channels
    channels-redis
    daphne
    dj-database-url
    django-celery-beat
    django-celery-email
    django-cors-headers
    django-health-check
    django-redis
    django-storages
<<<<<<< HEAD
    drf-jwt
=======
    django-cachalot
    djangorestframework-simplejwt
>>>>>>> d93a2b7f43ab (baserow package)
    drf-spectacular
    faker
    gunicorn
    importlib-resources
    itsdangerous
    pillow
    pyparsing
    psutil
    psycopg2
    redis
    regex
    requests
    service-identity
    setuptools
    tqdm
    twisted
    unicodecsv
    uvicorn
    watchgod
<<<<<<< HEAD
    zipp
  ] ++ uvicorn.optional-dependencies.standard;

  postInstall = ''
=======
    loguru
    zipp
    # OpenTelemetry dependencies…
    opentelemetry-api
    opentelemetry-exporter-otlp-proto-http
    opentelemetry-instrumentation-asgi
    opentelemetry-instrumentation-aiohttp-client
    opentelemetry-instrumentation-botocore
    opentelemetry-instrumentation-celery
    opentelemetry-instrumentation-dbapi
    opentelemetry-instrumentation-django
    opentelemetry-instrumentation-grpc
    opentelemetry-instrumentation-logging
    opentelemetry-instrumentation-psycopg2
    opentelemetry-instrumentation-redis
    opentelemetry-instrumentation-requests
    opentelemetry-instrumentation-wsgi
    opentelemetry-instrumentation
    opentelemetry-sdk
    opentelemetry-semantic-conventions
    opentelemetry-util-http

  ] ++ uvicorn.optional-dependencies.standard;

  postInstall = ''
    chmod +x $out/bin/baserow
    wrapProgram $out/bin/baserow \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --prefix DJANGO_SETTINGS_MODULE : "baserow.config.settings.base"
  '';

  nativeCheckInputs = [
    baserow_premium
    boto3
    freezegun
    httpretty
    openapi-spec-validator
    pyinstrument
    pytestCheckHook
    pytest-django
<<<<<<< HEAD
=======
    pytest-asyncio
>>>>>>> d93a2b7f43ab (baserow package)
    pytest-unordered
    responses
    zope-interface
  ];

  fixupPhase = ''
    cp -r src/baserow/contrib/database/{api,action,trash,formula,file_import} \
      $out/${python.sitePackages}/baserow/contrib/database/
    cp -r src/baserow/core/management/backup $out/${python.sitePackages}/baserow/core/management/
  '';

  disabledTests = [
    # Disable linting checks
    "flake8_plugins"
  ];

  disabledTestPaths = [
    # Disable premium tests
    "../premium/backend/src/baserow_premium"
    "../premium/backend/tests/baserow_premium"
    # Disable enterprise & premium tests
    # because they require a database.
    "../enterprise/backend/tests"
    "../enterprise/backend/src"
    "../premium/backend/tests"
    "../premium/backend/src"
    # Disable database related tests
    "tests/baserow/contrib/database"
    "tests/baserow/api"
    "tests/baserow/core"
    "tests/baserow/ws"
    # Requires an installed app or something, investigate later
    "tests/baserow/contrib/builder/"
  ];

  doCheck = false; # our disabled tests paths are not ignored for premium/backend because of an explicit testpaths I suppose.
  # todo patch it.

  pythonImportsCheck = [ "baserow" "baserow_premium.config.settings" "baserow_enterprise.config.settings" ];

  DJANGO_SETTINGS_MODULE = "baserow.config.settings.test";

  passthru = {
    ui = callPackage ./frontend.nix { };
    premium = baserow_premium;
    enterprise = baserow_enterprise;
    # PYTHONPATH of all dependencies used by the package
    inherit python;
    pythonPath = python.pkgs.makePythonPath propagatedBuildInputs;

    tests = {
      inherit (nixosTests) baserow;
    };
  };

  meta = with lib; {
    description = "No-code database and Airtable alternative";
    homepage = "https://baserow.io";
    license = licenses.mit;
    mainProgram = "baserow";
    maintainers = with maintainers; [ raitobezarius julienmalka ];
  };
}
