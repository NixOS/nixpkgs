{ lib
, python3
, fetchPypi
, nixosTests
}:

with python3.pkgs;

buildPythonPackage rec {
  pname = "HyperKitty";
  version = "1.3.8";
  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-j//Mrbos/g1BGenHRmOe5GvAza5nu/mchAgdLQu9h7g=";
  };

  postPatch = ''
    # isort is a development dependency
    sed -i '/isort/d' setup.py
  '';

  propagatedBuildInputs = [
    django
    django-gravatar2
    django-haystack
    django-mailman3
    django-q
    django-compressor
    django-extensions
    djangorestframework
    flufl_lock
    mistune
    networkx
    psycopg2
    python-dateutil
    robot-detection
  ];

  # Some of these are optional runtime dependencies that are not
  # listed as dependencies in setup.py.  To use these, they should be
  # dependencies of the Django Python environment, but not of
  # HyperKitty so they're not included for people who don't need them.
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
