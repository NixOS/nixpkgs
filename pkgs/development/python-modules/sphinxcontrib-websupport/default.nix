{ lib
, buildPythonPackage
, fetchPypi
, flit-core
, jinja2
, sphinxcontrib-serializinghtml
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-websupport";
  version = "1.2.6";
  format = "pyproject";

  src = fetchPypi {
    pname = "sphinxcontrib_websupport";
    inherit version;
    hash = "sha256-1ZK+jhEmG7vGRmjyWO/E/ULJOrYXQRFDtSRf4wxjPYw=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    jinja2
    sphinxcontrib-serializinghtml
  ];

  # circular dependency on sphinx
  dontCheckRuntimeDeps = true;
  doCheck = false;

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = {
    description = "Sphinx API for Web Apps";
    homepage = "http://sphinx-doc.org/";
    license = lib.licenses.bsd2;
  };
}
