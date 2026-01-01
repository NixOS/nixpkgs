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

<<<<<<< HEAD
  meta = {
    description = "Waitress WSGI server serving django";
    mainProgram = "waitress-serve-django";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ basvandijk ];
=======
  meta = with lib; {
    description = "Waitress WSGI server serving django";
    mainProgram = "waitress-serve-django";
    license = licenses.mit;
    maintainers = with maintainers; [ basvandijk ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
