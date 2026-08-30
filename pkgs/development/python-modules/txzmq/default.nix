{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
  pyzmq,
  twisted,
}:

buildPythonPackage rec {
  pname = "txzmq";
  version = "1.0.0";
  pyproject = true;

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchPypi {
    inherit version;
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
}
