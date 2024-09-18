{
  lib,
  buildPythonPackage,
  setuptools,
  django,
  waitress,
}:

let
  fs = lib.fileset;
in

buildPythonPackage {
  pname = "waitress-django";
  version = "1.0.0";
  pyproject = true;

  src = fs.toSource {
    root = ./.;
    fileset = fs.unions [
      ./setup.py
      ./src
    ];
  };

  build-system = [ setuptools ];

  pythonPath = [
    django
    waitress
  ];

  doCheck = false;

  meta = with lib; {
    description = "Waitress WSGI server serving django";
    mainProgram = "waitress-serve-django";
    license = licenses.mit;
    maintainers = with maintainers; [ basvandijk ];
  };
}
