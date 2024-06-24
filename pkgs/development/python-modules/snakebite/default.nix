{
  lib,
  buildPythonPackage,
  fetchPypi,
  protobuf,
}:

buildPythonPackage rec {
  pname = "snakebite";
  version = "2.11.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "085238b4944cb9c658ee62d5794de936ac3d0c337c504b2cc86424a205ae978a";
  };

  propagatedBuildInputs = [ protobuf ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'argparse'" ""
  '';

  # Tests require hadoop hdfs
  doCheck = false;

  pythonImportsCheck = [ "snakebite" ];

  meta = with lib; {
    description = "Pure Python HDFS client";
    mainProgram = "snakebite";
    homepage = "https://github.com/spotify/snakebite";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
