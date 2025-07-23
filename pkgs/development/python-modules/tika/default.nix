{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyyaml,
  requests,
}:

buildPythonPackage rec {
  pname = "tika";
  version = "3.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TDpATD2EZDfJQtam/Xtx1QKFaQ+uVImqim8A/5zND8c=";
  };

  propagatedBuildInputs = [
    pyyaml
    requests
  ];

  # Requires network
  doCheck = false;
  pythonImportsCheck = [ pname ];

  meta = with lib; {
    description = "Python binding to the Apache Tika™ REST services";
    mainProgram = "tika-python";
    homepage = "https://github.com/chrismattmann/tika-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ Flakebi ];
  };
}
