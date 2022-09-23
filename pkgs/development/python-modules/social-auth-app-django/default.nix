{ lib, buildPythonPackage, fetchFromGitHub, social-auth-core, django, python }:

buildPythonPackage rec {
  pname = "social-auth-app-django";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "python-social-auth";
    repo = "social-app-django";
    rev = version;
    sha256 = "sha256-ONhdXxclHRpVtijpKEZlmGDhjid/jnTaPq6LQtjxCC4=";
  };

  propagatedBuildInputs = [
    social-auth-core
  ];

  pythonImportsCheck = [ "social_django" ];

  checkInputs = [
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
