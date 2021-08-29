{ buildPythonPackage, fetchPypi, isPy27, lib, dateutil, lxml, requests
, pytestCheckHook }:

buildPythonPackage rec {
  pname = "webdavclient3";
  version = "3.14.5";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0yw3n5m70ysjn1ch48znpn4zr4a1bd0lsm7q2grqz7q5hfjzjwk0";
  };

  propagatedBuildInputs = [ dateutil lxml requests ];

  checkInputs = [ pytestCheckHook ];

  # disable tests completely, as most of them fail due to urllib3 not being able to establish a http connection
  doCheck = false;

  pythonImportsCheck = [ "webdav3.client" ];

  meta = with lib; {
    description = "Easy to use WebDAV Client for Python 3.x";
    homepage = "https://github.com/ezhov-evgeny/webdav-client-python-3";
    license = licenses.mit;
    maintainers = with maintainers; [ dmrauh ];
  };
}
