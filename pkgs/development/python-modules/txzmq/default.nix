{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pyzmq
, twisted
}:

buildPythonPackage rec {
  pname = "txzmq";
  version = "1.0.0";

  src = fetchPypi {
    inherit version;
    pname = "txZMQ";
    sha256 = "sha256-jWB9C/CcqUYAuOQvByHb5D7lOgRwGCNErHrOfljcYXc=";
  };

  propagatedBuildInputs = [
    pyzmq
    twisted
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "txzmq" ];

  meta = with lib; {
    description = "Twisted bindings for ZeroMQ";
    homepage = "https://github.com/smira/txZMQ";
    license = licenses.mpl20;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
