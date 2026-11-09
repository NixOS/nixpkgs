{
  lib,
  buildPythonPackage,
  fetchPypi,
  pbr,
  webob,
  simplegeneric,
  netaddr,
  importlib-metadata,
  # Test inputs
  transaction,
  pecan,
  sphinx,
  flask,
  flask-restful,
  webtest,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "wsme";
  version = "0.13.0";
  pyproject = true;

  src = fetchPypi {
    pname = "wsme";
    inherit (finalAttrs) version;
    hash = "sha256-W/MgEO2UPs+z8IeVpGAuJoPfXV6ozHHq8evj9EnzmDM=";
  };

  build-system = [ pbr ];

  dependencies = [
    webob
    simplegeneric
    netaddr
    importlib-metadata
  ];

  nativeCheckInputs = [
    transaction
    pecan
    sphinx
    flask
    flask-restful
    webtest
    pytestCheckHook
  ];

  meta = {
    description = "Simplify the writing of REST APIs, and extend them with additional protocols";
    homepage = "https://pythonhosted.org/WSME/";
    changelog = "https://pythonhosted.org/WSME/changes.html";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
})
