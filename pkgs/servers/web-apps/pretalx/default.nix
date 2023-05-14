{ lib
, gettext
, python3
, fetchFromGitHub
, nixosTests
, pretalx
}:

let
  python = python3.override {
    packageOverrides = self: super: {
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "pretalx";
  version = "2.3.1-494";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pretalx";
    repo = "pretalx";
    rev = "4b83cfd0f257fbf2dd5e34018cb47c825c3f1dec";
    hash = "sha256-3Ziqg7F0tJiMgxvhDK5rsBioo5Zyq9E5rz2BP4STwmE=";
  };

  outputs = [
    "out"
    "static"
  ];

  sourceRoot = "source/src";

  postPatch = ''
    substituteInPlace setup.py \
      --replace "django-filter==23.2" "django-filter" \
      --replace "django-formtools~=2.3.0" "django-formtools" \
      --replace "requests~=2.30.0" "requests"
  '';

  nativeBuildInputs = [
    gettext
  ];

  propagatedBuildInputs = with python.pkgs; [
    beautifulsoup4
    bleach
    celery
    csscompressor
    cssutils
    defusedcsv
    django
    django-bootstrap4
    django-compressor
    django-context-decorator
    django-countries
    django-csp
    django-filter
    django-formset-js-improved
    django-formtools
    django-hierarkey
    django-i18nfield
    django-libsass
    django-scopes
    djangorestframework
    inlinestyler
    libsass
    markdown
    pillow
    publicsuffixlist
    python-dateutil
    pytz
    qrcode
    reportlab
    requests
    rules
    urlman
    vobject
    whitenoise
    zxcvbn
  ];

  passthru.optional-dependencies = {
    mysql = with python.pkgs; [
      mysqlclient
    ];
    postgres = with python.pkgs; [
      psycopg2
    ];
    redis = with python.pkgs; [
      django-redis
      redis
    ];
  };

  postInstall = ''
    mkdir -p $out/bin
    cp ./manage.py $out/bin/pretalx-manage

    # the processed source files are in the static output
    rm -rf $out/${python.sitePackages}/pretalx/static

    # copy generated static files into dedicated output
    mkdir -p $static
    cp -r ./static.dist/** $static/

  '';

  nativeCheckInputs = with python3.pkgs; [
    faker
    freezegun
    pytest-django
    pytest-mock
    pytest-xdist
    pytestCheckHook
    responses
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  disabledTests = [
    # Expected to perform X queries or less but Y were done
    "test_schedule_export_public"
    "test_schedule_frab_json_export"
    "test_schedule_frab_xml_export"
  ];

  passthru = {
    inherit python;
    PYTHONPATH = "${python.pkgs.makePythonPath propagatedBuildInputs}:${pretalx.outPath}/${python.sitePackages}";
    tests = {
      inherit (nixosTests) pretalx;
    };
  };

  meta = with lib; {
    description = "Conference planning tool: CfP, scheduling, speaker management";
    homepage = "https://github.com/pretalx/pretalx";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
