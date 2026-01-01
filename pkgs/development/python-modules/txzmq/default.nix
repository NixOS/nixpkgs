{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pyzmq,
  twisted,
}:

buildPythonPackage rec {
  pname = "txzmq";
  version = "1.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "txZMQ";
    hash = "sha256-jWB9C/CcqUYAuOQvByHb5D7lOgRwGCNErHrOfljcYXc=";
  };

  propagatedBuildInputs = [
    pyzmq
    twisted
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "txzmq" ];

<<<<<<< HEAD
  meta = {
    description = "Twisted bindings for ZeroMQ";
    homepage = "https://github.com/smira/txZMQ";
    license = lib.licenses.mpl20;
=======
  meta = with lib; {
    description = "Twisted bindings for ZeroMQ";
    homepage = "https://github.com/smira/txZMQ";
    license = licenses.mpl20;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
