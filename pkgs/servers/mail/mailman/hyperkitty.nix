{
  lib,
  python3,
  fetchurl,
  nixosTests,
  fetchpatch,
}:

with python3.pkgs;

buildPythonPackage rec {
  pname = "hyperkitty";
  version = "1.3.12";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchurl {
    url = "https://gitlab.com/mailman/hyperkitty/-/releases/${version}/downloads/hyperkitty-${version}.tar.gz";
    hash = "sha256-3rWCk37FvJ6pwdXYa/t2pNpCm2Dh/qb9aWTnxmfPFh0=";
  };

  patches = [
    # Fix test with mistune >= 3.1
    (fetchpatch {
      url = "https://gitlab.com/mailman/hyperkitty/-/commit/2d69f420c603356a639a6b6243e1059a0089b7eb.patch";
      hash = "sha256-zo+dK8DFMkHlMrOVSUtelhAq+cxJE4gLG00LvuAlWKA=";
    })
    # Fix test with python 3.13
    # https://gitlab.com/mailman/hyperkitty/-/merge_requests/657
    (fetchpatch {
      url = "https://gitlab.com/mailman/hyperkitty/-/commit/6c3d402dc0981e545081a3baf13db7e491356e75.patch";
      hash = "sha256-ep9cFZe9/sIfIP80pLBOMYkJKWvNT7DRqg80DQSdRFw=";
    })
  ];

  build-system = [
    pdm-backend
  ];

  dependencies = [
    django
    django-gravatar2
    django-haystack
    django-mailman3
    django-q2
    django-compressor
    django-extensions
    djangorestframework
    flufl-lock
    mistune
    networkx
    psycopg2
    python-dateutil
    robot-detection
  ];

  # Some of these are optional runtime dependencies that are not
  # listed as dependencies in pyproject.toml.  To use these, they
  # should be dependencies of the Django Python environment, but not
  # of HyperKitty so they're not included for people who don't need
  # them.
  nativeCheckInputs = [
    beautifulsoup4
    elastic-transport
    elasticsearch
    mock
    whoosh
  ]
  ++ beautifulsoup4.optional-dependencies.lxml;

  checkPhase = ''
    cd $NIX_BUILD_TOP/$sourceRoot
    PYTHONPATH=.:$PYTHONPATH python example_project/manage.py test \
      --settings=hyperkitty.tests.settings_test hyperkitty
  '';

  passthru.tests = { inherit (nixosTests) mailman; };

  meta = {
    changelog = "https://docs.mailman3.org/projects/hyperkitty/en/latest/news.html";
    homepage = "https://www.gnu.org/software/mailman/";
    description = "Archiver for GNU Mailman v3";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ qyliss ];
  };
}
