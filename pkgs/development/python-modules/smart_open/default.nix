{ lib
, buildPythonPackage
, fetchPypi
, boto
, boto3
, bz2file
, mock
, moto
, requests
, responses
}:

buildPythonPackage rec {
  pname = "smart_open";
  version = "1.11.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "221cc08ae926af6ad72d141f208d228e1e801b1ee9b15f3e466eecf89d931002";
  };

  # nixpkgs version of moto is >=1.2.0, remove version pin to fix build
  postPatch = ''
    substituteInPlace ./setup.py --replace "moto==0.4.31" "moto"
  '';

  # moto>=1.0.0 is backwards-incompatible and some tests fail with it,
  # so disable tests for now
  doCheck = false;

  checkInputs = [ mock moto responses ];

  # upstream code requires both boto and boto3
  propagatedBuildInputs = [ boto boto3 bz2file requests ];
  meta = {
    license = lib.licenses.mit;
    description = "smart_open is a Python 2 & Python 3 library for efficient streaming of very large file";
    maintainers = with lib.maintainers; [ jyp ];
  };
}
