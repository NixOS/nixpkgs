{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
  pyzmq,
  twisted,
}:

buildPythonPackage (finalAttrs: {
  pname = "txzmq";
  version = "1.0.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "txZMQ";
    hash = "sha256-jWB9C/CcqUYAuOQvByHb5D7lOgRwGCNErHrOfljcYXc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyzmq
    twisted
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "txzmq" ];

  meta = {
    description = "Twisted bindings for ZeroMQ";
    homepage = "https://github.com/smira/txZMQ";
    license = lib.licenses.mpl20;
    maintainers = [ ];
  };
})
