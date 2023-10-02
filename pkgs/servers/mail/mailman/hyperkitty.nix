{ lib
, python3
, fetchPypi
}:

with python3.pkgs;

buildPythonPackage rec {
  pname = "HyperKitty";
  version = "1.3.7";
  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-TXSso+wwVGdBymIzns5yOS4pj1EdConmm87b/NyBAss=";
  };

  patches = [
    ./0001-Disable-broken-test_help_output-testcase.patch
  ];

  postPatch = ''
    # isort is a development dependency
    sed -i '/isort/d' setup.py
    # Fix mistune imports for mistune >= 2.0.0
    # https://gitlab.com/mailman/hyperkitty/-/merge_requests/379
    sed -i 's/mistune.scanner/mistune.util/' hyperkitty/lib/renderer.py
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
    elasticsearch
    mock
    whoosh
  ] ++ beautifulsoup4.optional-dependencies.lxml;

  checkPhase = ''
    cd $NIX_BUILD_TOP/$sourceRoot
    PYTHONPATH=.:$PYTHONPATH python example_project/manage.py test \
      --settings=hyperkitty.tests.settings_test hyperkitty
  '';

  meta = {
    homepage = "https://www.gnu.org/software/mailman/";
    description = "Archiver for GNU Mailman v3";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ globin qyliss ];
  };
}
