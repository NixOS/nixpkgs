{ lib
, fetchFromGitLab
, makeWrapper
, python3
}:

let

  baserow_premium = with python3.pkgs; ( buildPythonPackage rec {
    pname = "baserow_premium";
    version = "1.12.1";
    foramt = "setuptools";

    src = fetchFromGitLab {
      owner = "bramw";
      repo = pname;
      rev = "refs/tags/${version}";
      hash = "sha256-zT2afl3QNE2dO3JXjsZXqSmm1lv3EorG3mYZLQQMQ2Q=";
    };

    sourceRoot = "source/premium/backend";

    doCheck = false;
  });

in

with python3.pkgs; buildPythonPackage rec {
  pname = "baserow";
  version = "1.12.1";
  format = "setuptools";

  src = fetchFromGitLab {
    owner = "bramw";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-zT2afl3QNE2dO3JXjsZXqSmm1lv3EorG3mYZLQQMQ2Q=";
  };

  sourceRoot = "source/backend";

  postPatch = ''
    # remove dependency constraints
    sed 's/[~<>=].*//' -i requirements/base.in requirements/base.txt
    sed 's/zope-interface/zope.interface/' -i requirements/base.in requirements/base.txt
    sed 's/\[standard\]//' -i requirements/base.in requirements/base.txt
  '';

  nativeBuildInputs = [
    makeWrapper
  ];

  propagatedBuildInputs = [
    autobahn
    advocate
    antlr4-python3-runtime
    boto3
    cached-property
    celery-redbeat
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
    drf-jwt
    drf-spectacular
    faker
    gunicorn
    importlib-resources
    itsdangerous
    pillow
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
    zipp
  ] ++ uvicorn.optional-dependencies.standard;

  postInstall = ''
    wrapProgram $out/bin/baserow \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --prefix DJANGO_SETTINGS_MODULE : "baserow.config.settings.base"
  '';

  checkInputs = [
    baserow_premium
    boto3
    freezegun
    httpretty
    openapi-spec-validator
    pyinstrument
    pytestCheckHook
    pytest-django
    pytest-unordered
    responses
    zope_interface
  ];

  fixupPhase = ''
    cp -r src/baserow/contrib/database/{api,action,trash,formula,file_import} \
      $out/lib/${python.libPrefix}/site-packages/baserow/contrib/database/
    cp -r src/baserow/core/management/backup $out/lib/${python.libPrefix}/site-packages/baserow/core/management/
  '';

  disabledTests = [
    # Disable linting checks
    "flake8_plugins"
  ];

  disabledTestPaths = [
    # Disable premium tests
    "../premium/backend/src/baserow_premium"
    "../premium/backend/tests/baserow_premium"
    # Disable database related tests
    "tests/baserow/contrib/database"
    "tests/baserow/api"
    "tests/baserow/core"
    "tests/baserow/ws"
  ];

  DJANGO_SETTINGS_MODULE = "baserow.config.settings.test";

  meta = with lib; {
    description = "No-code database and Airtable alternative";
    homepage = "https://baserow.io";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
