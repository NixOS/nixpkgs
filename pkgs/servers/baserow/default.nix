{ lib
, buildPythonPackage
, fetchFromGitLab
, regex
, service-identity
, itsdangerous
, requests
, redis
, channels
, channels-redis
, psycopg2
, gunicorn
, django-cors-headers
, django-celery-email
, advocate
, django-storages
, pillow
, faker
, uvicorn
, twisted
, django
, drf-jwt
, cryptography
, tqdm
, celery-redbeat
, drf-spectacular
, websockets
, asgiref
, antlr4-python3-runtime
, psutil
, dj-database-url
, django-health-check
, celery
, unicodecsv
, django-celery-beat
, django-redis
, zipp
, boto3
, cached-property
, importlib-resources
, zope_interface
, freezegun
, pyinstrument
, responses
, pytestCheckHook
, setuptools
, pytest-django
, python
, httpretty
, pytest-unordered
, openapi-spec-validator }:

let

  baserow_premium = with python.pkgs; ( buildPythonPackage rec {
    pname = "baserow_premium";
    version = "1.10.2";

    src = fetchFromGitLab {
      owner = "bramw";
      repo = pname;
      rev = version;
      sha256 = "sha256-4BrhTwAxHboXz8sMZL0V68skgNw2D2/YJuiWVNe0p4w=";
    };

    sourceRoot = "source/premium/backend";

    doCheck = false;
  });

in

buildPythonPackage rec {
  pname = "baserow";
  version = "1.10.2";

  src = fetchFromGitLab {
    owner = "bramw";
    repo = pname;
    rev = version;
    sha256 = "sha256-4BrhTwAxHboXz8sMZL0V68skgNw2D2/YJuiWVNe0p4w=";
  };

  sourceRoot = "source/backend";

  postPatch = ''
    # remove dependency constraints
    sed 's/[~<>=].*//' -i requirements/base.in requirements/base.txt
    sed 's/zope-interface/zope.interface/' -i requirements/base.in requirements/base.txt
  '';

  propagatedBuildInputs = [
    advocate
    antlr4-python3-runtime
    boto3
    cached-property
    celery-redbeat
    channels
    channels-redis
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
    zipp
  ];

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

  # Disable linting checks
  disabledTests = [
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
    homepage = "https://baserow.io";
    description = "No-code database and Airtable alternative";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
