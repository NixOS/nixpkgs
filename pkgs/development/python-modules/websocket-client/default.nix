{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytestCheckHook
, pysocks
}:

buildPythonPackage rec {
  pname = "websocket-client";
  version = "1.1.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-to5JWdcEdo+iDjXJ1QjI3Cu8BB/Y0mfA1zRc/+KCRWg=";
  };

  checkInputs = [ pytestCheckHook pysocks ];

  pythonImportsCheck = [ "websocket" ];

  meta = with lib; {
    description = "Websocket client for Python";
    homepage = "https://github.com/websocket-client/websocket-client";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ fab ];
    changelog = "https://github.com/websocket-client/websocket-client/blob/v${version}/ChangeLog";
  };
}
