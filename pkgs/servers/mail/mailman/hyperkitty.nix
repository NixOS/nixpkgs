{ lib
, python3
, fetchurl
, nixosTests
}:

with python3.pkgs;

buildPythonPackage rec {
  pname = "HyperKitty";
  version = "1.3.9";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchurl {
    url = "https://gitlab.com/mailman/hyperkitty/-/releases/${version}/downloads/hyperkitty-${version}.tar.gz";
    hash = "sha256-BfhCh4zZcfwoIfubW/+MUWXwh1yFOH/jpRdQdsj6lME=";
  };

  nativeBuildInputs = [
    pdm-backend
  ];

  propagatedBuildInputs = [
    django
    django-gravatar2
    django-haystack
    django-mailman3
    django-q
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
  ] ++ beautifulsoup4.optional-dependencies.lxml;

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
