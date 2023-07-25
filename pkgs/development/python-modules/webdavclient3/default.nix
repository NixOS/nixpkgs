{ buildPythonPackage, fetchPypi, isPy27, lib, python-dateutil, lxml, requests
, pytestCheckHook }:

buildPythonPackage rec {
  pname = "webdavclient3";
  version = "3.14.6";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "bcd22586bb0d58abc26ca56054fd04228e704bd36073c3080f4597c1556c880d";
  };

  propagatedBuildInputs = [ python-dateutil lxml requests ];

  nativeCheckInputs = [ pytestCheckHook ];

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
