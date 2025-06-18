{
  lib,
  buildPythonPackage,
  deepmerge,
  fetchPypi,
  isPy27,
  setuptools-scm,
  jsonschema,
  picobox,
  pyyaml,
  sphinx-mdinclude,
  sphinxcontrib-httpdomain,
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-openapi";
  version = "0.8.4";
  format = "setuptools";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-34g4CKW15LQROtaXGFxDo/Qt89znBFOveLpwdpB+miA=";
  };

  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [
    deepmerge
    jsonschema
    picobox
    pyyaml
    sphinx-mdinclude
    sphinxcontrib-httpdomain
  ];

  doCheck = false;

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = with lib; {
    homepage = "https://github.com/ikalnytskyi/sphinxcontrib-openapi";
    description = "OpenAPI (fka Swagger) spec renderer for Sphinx";
    license = licenses.bsd0;
    maintainers = [ maintainers.flokli ];
  };
}
