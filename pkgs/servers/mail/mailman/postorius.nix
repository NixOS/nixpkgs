{ stdenv, buildPythonPackage, fetchPypi, beautifulsoup4, vcrpy, mock
, django-mailman3, mailmanclient, readme_renderer
}:

buildPythonPackage rec {
  pname = "postorius";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "027k70p1a4glskymbw4vw3fj460a9ipgcnns7xidp604s1fwz7lx";
  };

  buildInputs = [ beautifulsoup4 vcrpy mock ];
  propagatedBuildInputs = [ django-mailman3 readme_renderer ];

  # The test suite is broken. :-( There are tons of failed attempts to connect
  # to some local service. I'm not sure what is going on. Needs debugging.
  doCheck = false;
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
