{ lib
, backports_ssl_match_hostname
, buildPythonPackage
, fetchPypi
, isPy27
, pytestCheckHook
, six
}:

buildPythonPackage rec {
  pname = "websocket_client";
  version = "0.58.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Y1CbQdFYrlt/Z+tK0g/su07umUNOc+FANU3D/44JcW8=";
  };

  propagatedBuildInputs = [
    six
  ] ++ lib.optional isPy27 backports_ssl_match_hostname;

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "websocket" ];

  meta = with lib; {
    description = "Websocket client for Python";
    homepage = "https://github.com/websocket-client/websocket-client";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ fab ];
  };
}
