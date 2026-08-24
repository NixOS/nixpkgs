{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyyaml,
  requests,
}:

buildPythonPackage rec {
  pname = "tika";
  version = "3.3.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RopTAiSRYjUfZc/gVjLThpwDUNcmrvgqdeewT6XKyKs=";
  };

  propagatedBuildInputs = [
    pyyaml
    requests
  ];

  # Requires network
  doCheck = false;
  pythonImportsCheck = [ pname ];

  meta = {
    description = "Python binding to the Apache Tika™ REST services";
    mainProgram = "tika-python";
    homepage = "https://github.com/chrismattmann/tika-python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ Flakebi ];
  };
}
