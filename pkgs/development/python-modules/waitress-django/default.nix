{ buildPythonPackage, django, waitress }:

buildPythonPackage {
  pname = "waitress-django";
  version = "0.0.0";

  src = ./.;
  requiredPythonModules = [ django waitress ];
  doCheck = false;
  meta.description = "A waitress WSGI server serving django";
}
