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
    hash = "sha256-CFI4tJRMucZY7mLVeU3pNqw9DDN8UEssyGQkogWul4o=";
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
