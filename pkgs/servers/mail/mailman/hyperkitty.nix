{ lib
, python3
, fetchpatch
}:

with python3.pkgs;

buildPythonPackage rec {
  pname = "HyperKitty";
  # Note: Mailman core must be on the latest version before upgrading HyperKitty.
  # See: https://gitlab.com/mailman/postorius/-/issues/516#note_544571309
  version = "1.3.5";
  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-gmkiK8pIHfubbbxNdm/D6L2o722FptxYgINYdIUOn4Y=";
  };

  patches = [
    # FIXME: backport Python 3.10 support fix, remove for next release
    (fetchpatch {
      url = "https://gitlab.com/mailman/hyperkitty/-/commit/551a44a76e46931fc5c1bcb341235d8f579820be.patch";
      sha256 = "sha256-5XCrvyrDEqH3JryPMoOXSlVVDLQ+PdYBqwGYxkExdvk=";
      includes = [ "hyperkitty/*" ];
    })

    # Fix for Python >=3.9.13
    (fetchpatch {
      url = "https://gitlab.com/mailman/hyperkitty/-/commit/3efe7507944dbdbfcfa4c182d332528712476b28.patch";
      sha256 = "sha256-yXuhTbmfDiYEXEsnz+zp+xLHRqI4GtkOhGHN+37W0iQ=";
    })
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
  checkInputs = [
    beautifulsoup4
    elasticsearch
    mock
    whoosh
  ];

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
