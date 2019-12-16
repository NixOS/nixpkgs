{ stdenv, buildPythonPackage, fetchPypi, coverage, mock, flufl_lock
, robot-detection, django_extensions, rjsmin, cssmin, django-mailman3
, django-haystack, lockfile, networkx, dateutil, defusedxml
, django-paintstore, djangorestframework, django, django-q
, django_compressor, beautifulsoup4, six, psycopg2, whoosh, isort
}:

buildPythonPackage rec {
  pname = "HyperKitty";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0agqd3hicygq7jixf6n54d5ljdlbif514hv3j7jq8hsfr9lpnay6";
  };

  buildInputs = [ coverage mock ];
  propagatedBuildInputs = [
    robot-detection django_extensions rjsmin cssmin django-mailman3
    django-haystack lockfile networkx dateutil defusedxml
    django-paintstore djangorestframework django django-q flufl_lock
    django_compressor beautifulsoup4 six psycopg2 whoosh isort
  ];

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
