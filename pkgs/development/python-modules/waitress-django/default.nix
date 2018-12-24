{ buildPythonPackage, django_2_0, waitress }:

buildPythonPackage rec {
  pname = "waitress-django";
  version = "0.0.0";

  src = ./.;
  pythonPath = [ django_2_0 waitress ];
  doCheck = false;
  meta.description = "A waitress WSGI server serving django";
}
