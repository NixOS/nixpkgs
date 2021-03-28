{ lib, buildPythonPackage, fetchPypi, beautifulsoup4, vcrpy, mock
, django-mailman3, mailmanclient, readme_renderer
}:

buildPythonPackage rec {
  pname = "postorius";
  version = "1.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-L2ApUGQNvR0UVvodVM+wMzjYLZkegI4fT4yUiU/cibU=";
  };

  propagatedBuildInputs = [ django-mailman3 readme_renderer ];
  checkInputs = [ beautifulsoup4 vcrpy mock ];

  # Tries to connect to database.
  doCheck = false;

  meta = with lib; {
    homepage = "https://docs.mailman3.org/projects/postorius";
    description = "Web-based user interface for managing GNU Mailman";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ globin peti ];
  };
}
