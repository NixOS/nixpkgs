{ stdenv, buildPythonPackage, fetchPypi, isPy3k, isort, coverage, mock
, robot-detection, django_extensions, rjsmin, cssmin, django-mailman3
, django-haystack, flufl_lock, networkx, dateutil, defusedxml
, django-paintstore, djangorestframework, django, django-q
, django_compressor, beautifulsoup4, six, psycopg2, whoosh, elasticsearch
}:

buildPythonPackage rec {
  pname = "HyperKitty";
  version = "1.3.2";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "092fkv0xyf5vgj33xwq0mh9h5c5d56ifwimaqbfpx5cwc6yivb88";
  };

  nativeBuildInputs = [ isort ];
  propagatedBuildInputs = [
    robot-detection django_extensions rjsmin cssmin django-mailman3
    django-haystack flufl_lock networkx dateutil defusedxml
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
    homepage = "http://www.gnu.org/software/mailman/";
    description = "Archiver for GNU Mailman v3";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ peti globin ];
  };
}
