{ lib, buildPythonPackage, django, waitress }:

buildPythonPackage {
  pname = "waitress-django";
  version = "1.0.0";
  format = "setuptools";

  src = ./.;
  pythonPath = [ django waitress ];
  doCheck = false;

  meta = with lib; {
    description = "A waitress WSGI server serving django";
    license = licenses.mit;
    maintainers = with maintainers; [ basvandijk ];
  };
}
