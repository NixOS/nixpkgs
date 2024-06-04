{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  requests,
  six,
}:

buildPythonPackage rec {
  pname = "sseclient";
  version = "0.0.27";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sv5TTcszsdP6rRPWDFp8cY4o+FmH8qA07PXsJ5kYwRw=";
  };

  propagatedBuildInputs = [
    requests
    six
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [ "event_stream" ];

  meta = with lib; {
    description = "Client library for reading Server Sent Event streams";
    homepage = "https://github.com/btubbs/sseclient";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
