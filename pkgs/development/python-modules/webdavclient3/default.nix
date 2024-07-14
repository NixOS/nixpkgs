{
  buildPythonPackage,
  fetchPypi,
  isPy27,
  lib,
  python-dateutil,
  lxml,
  requests,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "webdavclient3";
  version = "3.14.6";
  format = "setuptools";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vNIlhrsNWKvCbKVgVP0EIo5wS9Ngc8MID0WXwVVsiA0=";
  };

  propagatedBuildInputs = [
    python-dateutil
    lxml
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # disable tests completely, as most of them fail due to urllib3 not being able to establish a http connection
  doCheck = false;

  pythonImportsCheck = [ "webdav3.client" ];

  meta = with lib; {
    description = "Easy to use WebDAV Client for Python 3.x";
    mainProgram = "wdc";
    homepage = "https://github.com/ezhov-evgeny/webdav-client-python-3";
    license = licenses.mit;
    maintainers = with maintainers; [ dmrauh ];
  };
}
