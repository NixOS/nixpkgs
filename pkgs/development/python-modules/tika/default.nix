{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyyaml,
  requests,
}:

buildPythonPackage rec {
  pname = "tika";
  version = "2.6.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VmcOuBKUTrJe1z8bOwdapB56E1t0skCCLyi4GeWzc9o=";
  };

  propagatedBuildInputs = [
    pyyaml
    requests
  ];

  # Requires network
  doCheck = false;
  pythonImportsCheck = [ pname ];

  meta = with lib; {
    description = "A Python binding to the Apache Tika™ REST services";
    mainProgram = "tika-python";
    homepage = "https://github.com/chrismattmann/tika-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ Flakebi ];
  };
}
