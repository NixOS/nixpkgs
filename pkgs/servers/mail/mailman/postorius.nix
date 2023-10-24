{ lib, python3, fetchPypi }:

with python3.pkgs;

buildPythonPackage rec {
  pname = "postorius";
  version = "1.3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1mSt+PVx3xUJDc5JwrCmKiRNIDwbsjjbM2Fi5Sgz6h8=";
  };

  propagatedBuildInputs = [ django-mailman3 readme_renderer ];
  nativeCheckInputs = [ beautifulsoup4 vcrpy mock ];

  # Tries to connect to database.
  doCheck = false;

  meta = with lib; {
    homepage = "https://docs.mailman3.org/projects/postorius";
    description = "Web-based user interface for managing GNU Mailman";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ qyliss ];
  };
}
