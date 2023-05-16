{ lib
, buildPythonPackage
, fetchPypi
, protobuf
}:

buildPythonPackage rec {
  pname = "snakebite";
  version = "2.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "085238b4944cb9c658ee62d5794de936ac3d0c337c504b2cc86424a205ae978a";
  };

  propagatedBuildInputs = [
    protobuf
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'argparse'" ""
  '';

  # Tests require hadoop hdfs
  doCheck = false;

  pythonImportsCheck = [
    "snakebite"
  ];

  meta = with lib; {
    description = "Pure Python HDFS client";
    homepage = "https://github.com/spotify/snakebite";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
