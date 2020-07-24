{ lib, buildPythonPackage, fetchFromGitHub, isPy27
, maya
, requests
}:

buildPythonPackage rec {
  version = "0.2.1";
  pname = "secure";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "typeerror";
    repo = "secure.py";
    rev = "v${version}";
    sha256 = "1nbxwi0zccrha6js14ibd596kdi1wpqr7jgs442mqclw4b3f77q5";
  };

  propagatedBuildInputs = [ maya requests ];

  # no tests in release
  doCheck = false;

  pythonImportsCheck = [ "secure" ];

  meta = with lib; {
    description = "Adds optional security headers and cookie attributes for Python web frameworks";
    homepage = "https://github.com/TypeError/secure.py";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
