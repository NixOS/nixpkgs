{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPy27,
  maya,
  requests,
}:

buildPythonPackage rec {
  version = "0.3.0";
  format = "setuptools";
  pname = "secure";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "typeerror";
    repo = "secure.py";
    rev = version;
    sha256 = "1ajz1nx0nnhsc80xbgbc42ib2h08qnccvsp5i583rd9b0f9pklwk";
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
    maintainers = with maintainers; [ jonringer ];
  };
}
