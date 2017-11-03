{ buildPythonPackage, django_1_8, waitress }:
buildPythonPackage {
  name = "waitress-django";
  src = ./.;
  pythonPath = [ django_1_8 waitress ];
  doCheck = false;
  meta.description = "A waitress WSGI server serving django";
}
