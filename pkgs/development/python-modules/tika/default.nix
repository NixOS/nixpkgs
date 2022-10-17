{ lib
, buildPythonPackage
, fetchPypi
, pyyaml
, requests
}:

buildPythonPackage rec {
  pname = "tika";
  version = "1.24";

  src = fetchPypi {
    inherit pname version;
    sha256 = "wsUPQFYi90UxhBEE+ehcF1Ea7eEd6OU4XqsaKaMfGRs=";
  };

  propagatedBuildInputs = [ pyyaml requests ];

  # Requires network
  doCheck = false;
  pythonImportsCheck = [ pname ];

  meta = with lib; {
    description = "A Python binding to the Apache Tika™ REST services";
    homepage = "https://github.com/chrismattmann/tika-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ Flakebi ];
  };
}
