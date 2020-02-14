{ lib
, buildPythonPackage
, fetchPypi
, tox
, virtualenv
, protobuf
}:

buildPythonPackage rec {
  pname = "snakebite";
  version = "2.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "085238b4944cb9c658ee62d5794de936ac3d0c337c504b2cc86424a205ae978a";
  };

  checkInputs = [
    tox
    virtualenv
  ];

  propagatedBuildInputs = [
    protobuf
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'argparse'" ""
  '';

  # tests require hadoop hdfs
  doCheck = false;

  meta = with lib; {
    description = "Pure Python HDFS client";
    homepage = https://github.com/spotify/snakebite;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
