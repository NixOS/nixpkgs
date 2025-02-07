{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPy27,
  maya,
  requests,
}:

buildPythonPackage rec {
  version = "1.0.1";
  format = "setuptools";
  pname = "secure";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "typeerror";
    repo = "secure.py";
    tag = "v${version}";
    sha256 = "sha256-lyosOejztFEINGKO0wAYv3PWBL7vpmAq+eQunwP9h5I=";
  };

  propagatedBuildInputs = [
    maya
    requests
  ];

  # no tests in release
  doCheck = false;

  pythonImportsCheck = [ "secure" ];

  meta = with lib; {
    description = "Adds optional security headers and cookie attributes for Python web frameworks";
    homepage = "https://github.com/TypeError/secure.py";
    license = licenses.mit;
    maintainers = [ ];
  };
}
