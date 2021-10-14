{ lib
, buildPythonPackage
, fetchFromGitLab
, isPy3k

# dependencies
, defusedxml
, django
, django-gravatar2
, django-haystack
, django-mailman3
, django-paintstore
, django-q
, django_compressor
, django_extensions
, djangorestframework
, flufl_lock
, mistune_2_0
, networkx
, psycopg2
, python-dateutil
, robot-detection

# tests
, beautifulsoup4
, elasticsearch
, mock
, whoosh
}:

buildPythonPackage rec {
  pname = "HyperKitty";
  # Note: Mailman core must be on the latest version before upgrading HyperKitty.
  # See: https://gitlab.com/mailman/postorius/-/issues/516#note_544571309
  #
  # Update to next stable version > 1.3.4 that has fixed tests, see
  # https://gitlab.com/mailman/django-mailman3/-/issues/48
  version = "1.3.5";
  disabled = !isPy3k;

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "mailman";
    repo = "hyperkitty";
    rev = version;
    sha256 = "0v70r0r6w0q56hk2hw1qp3ci0bwd9x8inf4gai6ybjqjfskqrxi4";
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
    django_compressor
    django_extensions
    djangorestframework
    flufl_lock
    mistune_2_0
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
