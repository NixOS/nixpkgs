{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  webob,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "wsgiproxy2";
  version = "0.5.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "gawel";
    repo = "WSGIProxy2";
    rev = version;
    hash = "sha256-ouofw3cBQzBwSh3Pdtdl7KI2pg/T/z3qoh8zoeiKiSs=";
  };

  propagatedBuildInputs = [ webob ];

  # Circular dependency on webtest
  doCheck = false;

  pythonImportsCheck = [ "wsgiproxy" ];

  meta = with lib; {
    description = "HTTP proxying tools for WSGI apps";
    homepage = "https://wsgiproxy2.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ domenkozar ];
  };
}
