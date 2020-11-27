{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
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
  version = "4.0.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2ce157700821e285bbacd8d01ec7a4f2582765460e541f55b216cb135db8be24";
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
