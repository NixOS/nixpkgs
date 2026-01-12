{
  lib,
  buildPythonPackage,
  setuptools,
  django,
  waitress,
}:

buildPythonPackage {
  pname = "waitress-django";
  version = "1.0.0";
  pyproject = true;

  src = ./src;

  build-system = [ setuptools ];

  pythonPath = [
    django
    waitress
  ];

  doCheck = false;

  meta = {
    description = "Waitress WSGI server serving django";
    mainProgram = "waitress-serve-django";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ basvandijk ];
  };
}
