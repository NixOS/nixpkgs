{ stdenv, fetchgit, which, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  name = "euca2ools-2.1.3";
  namePrefix = "";

  src = fetchgit {
    url = https://github.com/eucalyptus/euca2ools.git;
    rev = "8ae2ecc";
    sha256 = "caef5a3e2c9b515fd815034b5b7304acc878a0b9777ae4208dc033b0bf39da2b";
  };

  pythonPath = [ pythonPackages.boto pythonPackages.m2crypto ];

  doCheck = false;

  meta = {
    homepage = http://open.eucalyptus.com/downloads;
    description = "Tools for interacting with Amazon EC2/S3-compatible cloud computing services";
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.linux;
  };
}
