{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  webob,
}:

buildPythonPackage rec {
  pname = "wsgiproxy2";
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gawel";
    repo = "WSGIProxy2";
    rev = version;
    hash = "sha256-ouofw3cBQzBwSh3Pdtdl7KI2pg/T/z3qoh8zoeiKiSs=";
  };

  build-system = [ setuptools ];

  dependencies = [ webob ];

  # Circular dependency on webtest
  doCheck = false;

  pythonImportsCheck = [ "wsgiproxy" ];

  meta = {
    description = "HTTP proxying tools for WSGI apps";
    homepage = "https://wsgiproxy2.readthedocs.io/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
