{ lib
, buildPythonPackage
, fetchPypi
, python
, six
, social-auth-core
, mock
, django
}:

buildPythonPackage rec {
  pname = "social-auth-app-django";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1shdzc5rwmi8vl4wf28iw1jmbdfd36r5r26xglszy4dxizpqphmp";
  };

  propagatedBuildInputs = [
    six
    social-auth-core
  ];

  checkInputs = [
    mock
    django
  ];

  checkPhase = ''
    mkdir tests/templates
    echo -n test > tests/templates/test.html
    ${python.interpreter} manage.py test
  '';

  meta = with lib; {
    description = "Python Social Authentication, Django integration";
    homepage = https://github.com/python-social-auth/social-app-django;
    license = licenses.bsd3;
    maintainers = with maintainers; [ jtojnar ];
  };
}
