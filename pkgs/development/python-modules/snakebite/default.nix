{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  protobuf,
}:

buildPythonPackage rec {
  pname = "snakebite";
  version = "2.11.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CFI4tJRMucZY7mLVeU3pNqw9DDN8UEssyGQkogWul4o=";
  };

  build-system = [ setuptools ];

  dependencies = [ protobuf ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "'argparse'" ""
  '';

  # Tests require hadoop hdfs
  doCheck = false;

  pythonImportsCheck = [ "snakebite" ];

  meta = with lib; {
    description = "Pure Python HDFS client";
    mainProgram = "snakebite";
    homepage = "https://github.com/spotify/snakebite";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
