{ stdenv, buildPythonPackage, fetchPypi, coverage, mock
, robot-detection, django_extensions, rjsmin, cssmin, django-mailman3
, django-haystack, lockfile, networkx, dateutil, defusedxml
, django-paintstore, djangorestframework, django, django-q
, django_compressor, beautifulsoup4, six, psycopg2, whoosh
}:

buildPythonPackage rec {
  pname = "HyperKitty";
  version = "1.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1z2zswlml6nppxhzw9a4nrj7i5wsxd29s3q78ka1rwr5m5n7s1rz";
  };

  buildInputs = [ coverage mock ];
  propagatedBuildInputs = [
    robot-detection django_extensions rjsmin cssmin django-mailman3
    django-haystack lockfile networkx dateutil defusedxml
    django-paintstore djangorestframework django django-q
    django_compressor beautifulsoup4 six psycopg2 whoosh
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
