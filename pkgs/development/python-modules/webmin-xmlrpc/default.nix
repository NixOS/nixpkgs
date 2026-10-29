{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "webmin-xmlrpc";
  version = "0.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "autinerd";
    repo = "webmin-xmlrpc";
    tag = finalAttrs.version;
    hash = "sha256-qCS5YV3o7ozO7fDaJucQvU0dEyTbxTivtTDKQVY4pkM=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  pythonImportsCheck = [ "webmin_xmlrpc" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    changelog = "https://github.com/autinerd/webmin-xmlrpc/releases/tag/${finalAttrs.version}";
    description = "Python interface to interact with the Webmin XML-RPC API";
    homepage = "https://github.com/autinerd/webmin-xmlrpc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
