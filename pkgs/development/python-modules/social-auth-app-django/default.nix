{ lib, buildPythonPackage, fetchFromGitHub, social-auth-core, django, python }:

buildPythonPackage rec {
  pname = "social-auth-app-django";
<<<<<<< HEAD
  version = "5.3.0";
=======
  version = "5.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "python-social-auth";
    repo = "social-app-django";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-YJsE8YfLaUsBjwehheic6YG+6robWeBzKL3T7V0c8E8=";
=======
    hash = "sha256-GLOZfiSXkUnTK8Mxg+5jbxkE6Mo0kW5vMZsPe9G/dpU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    social-auth-core
  ];

  pythonImportsCheck = [ "social_django" ];

  nativeCheckInputs = [
    django
  ];

  checkPhase = ''
    ${python.interpreter} -m django test --settings="tests.settings"
  '';

  meta = with lib; {
    homepage = "https://github.com/python-social-auth/social-app-django";
    description = "Python Social Auth - Application - Django";
    license = licenses.bsd3;
    maintainers = with maintainers; [ n0emis ];
  };
}
