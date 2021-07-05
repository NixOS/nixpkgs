{ lib, buildPythonPackage, fetchPypi, isPy3k, isort, coverage, mock
, robot-detection, django_extensions, rjsmin, cssmin, django-mailman3
, django-haystack, flufl_lock, networkx, python-dateutil, defusedxml
, django-paintstore, djangorestframework, django, django-q
, django_compressor, beautifulsoup4, six, psycopg2, whoosh, elasticsearch
}:

buildPythonPackage rec {
  pname = "HyperKitty";
  # Note: Mailman core must be on the latest version before upgrading HyperKitty.
  # See: https://gitlab.com/mailman/postorius/-/issues/516#note_544571309
  version = "1.3.4";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lbh8n66fp3l5s0xvmvsbfvgs3z4knx0gwf0q117n2nfkslf13zp";
  };

  nativeBuildInputs = [ isort ];
  propagatedBuildInputs = [
    robot-detection django_extensions rjsmin cssmin django-mailman3
    django-haystack flufl_lock networkx python-dateutil defusedxml
    django-paintstore djangorestframework django django-q
    django_compressor six psycopg2 isort
  ];

  # Some of these are optional runtime dependencies that are not
  # listed as dependencies in setup.py.  To use these, they should be
  # dependencies of the Django Python environment, but not of
  # HyperKitty so they're not included for people who don't need them.
  checkInputs = [ beautifulsoup4 coverage elasticsearch mock whoosh ];

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
    maintainers = with lib.maintainers; [ peti globin qyliss ];
  };
}
