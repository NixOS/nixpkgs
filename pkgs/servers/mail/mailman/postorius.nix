{ stdenv, buildPythonPackage, fetchPypi, beautifulsoup4, vcrpy, mock
, django-mailman3, mailmanclient
}:

buildPythonPackage rec {
  pname = "postorius";
  version = "1.2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1722lnscxfl8wdigf5d80d1qmd5gblr439wa989jxlww0wkjg9fl";
  };

  buildInputs = [ beautifulsoup4 vcrpy mock ];
  propagatedBuildInputs = [ django-mailman3 ];

  checkPhase = ''
    cd $NIX_BUILD_TOP/$sourceRoot
    PYTHONPATH=.:$PYTHONPATH python example_project/manage.py test --settings=test_settings postorius
  '';

  meta = {
    homepage = https://www.gnu.org/software/mailman/;
    description = "Web-based user interface for managing GNU Mailman";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ globin peti ];
  };
}
