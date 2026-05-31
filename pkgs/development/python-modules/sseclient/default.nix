{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  requests,
  six,
}:

buildPythonPackage rec {
  pname = "sseclient";
  version = "0.0.27";
  format = "setuptools";

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

  meta = {
    description = "Client library for reading Server Sent Event streams";
    homepage = "https://github.com/btubbs/sseclient";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ peterhoeg ];
  };
}
