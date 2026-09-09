{
  lib,
  buildPythonPackage,
  decorator,
  fetchPypi,
  setuptools,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "stashy";
  version = "0.7";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-mWWqGFCbdXa71LBoli2amkgozsjOIu5aNl3bzr/6CfU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    decorator
    requests
  ];

  # Tests require internet connection
  doCheck = false;
  pythonImportsCheck = [ "stashy" ];

  meta = {
    description = "Python client for the Atlassian Bitbucket Server (formerly known as Stash) REST API";
    homepage = "https://github.com/cosmin/stashy";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mupdt ];
  };
})
