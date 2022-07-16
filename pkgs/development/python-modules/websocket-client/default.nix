{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytestCheckHook
, python-socks
, six
}:

buildPythonPackage rec {
  pname = "websocket-client";
  version = "1.3.3";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1YxfKE1qm/g3natCMln+j4W3DV+l0pFtV5GoRZSxIrE=";
  };

  propagatedBuildInputs = [
    python-socks
    six
   ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "websocket" ];

  meta = with lib; {
    description = "Websocket client for Python";
    homepage = "https://github.com/websocket-client/websocket-client";
    changelog = "https://github.com/websocket-client/websocket-client/blob/v${version}/ChangeLog";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ fab ];
  };
}
