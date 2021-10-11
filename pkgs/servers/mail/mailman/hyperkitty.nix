{ lib, buildPythonPackage, fetchFromGitLab, isPy3k, isort, coverage, mock
, robot-detection, django_extensions, rjsmin, cssmin, django-mailman3
, django-haystack, flufl_lock, mistune_2_0, networkx, python-dateutil, defusedxml
, django-paintstore, djangorestframework, django, django-q
, django_compressor, beautifulsoup4, six, psycopg2, whoosh, elasticsearch
}:

buildPythonPackage rec {
  pname = "HyperKitty";
  # Note: Mailman core must be on the latest version before upgrading HyperKitty.
  # See: https://gitlab.com/mailman/postorius/-/issues/516#note_544571309
  #
  # Update to next stable version > 1.3.4 that has fixed tests, see
  # https://gitlab.com/mailman/django-mailman3/-/issues/48
  version = "unstable-2021-10-08";
  disabled = !isPy3k;

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "mailman";
    repo = "hyperkitty";
    rev = "ec9c8ed18798cf8f7e89dfaba0014dcdfa207f27";
    sha256 = "12kxb6pra31f51yxzx010jk2wlacdsbyf6fbl1cczjgxgb4cpy4i";
  };

  nativeBuildInputs = [ isort ];
  propagatedBuildInputs = [
    robot-detection django_extensions rjsmin cssmin django-mailman3
    django-haystack flufl_lock mistune_2_0 networkx python-dateutil defusedxml
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
