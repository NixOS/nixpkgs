{ stdenv, buildPythonPackage, fetchPypi, beautifulsoup4, vcrpy, mock
, django-mailman3, mailmanclient, readme_renderer
}:

buildPythonPackage rec {
  pname = "postorius";
  version = "1.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wrm0hda7ym9qaygxirqaaii66ndmgyy7gx8wqdg07pfx14zcyja";
  };

  propagatedBuildInputs = [ django-mailman3 readme_renderer ];
  checkInputs = [ beautifulsoup4 vcrpy mock ];

  # Tries to connect to database.
  doCheck = false;

  meta = {
    homepage = https://www.gnu.org/software/mailman/;
    description = "Web-based user interface for managing GNU Mailman";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ globin peti ];
  };
}
