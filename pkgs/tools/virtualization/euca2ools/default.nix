{ stdenv, fetchgit, which, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  name = "euca2ools-2.0.0-pre-20111230";
  namePrefix = "";

  src = fetchgit {
    url = https://github.com/eucalyptus/euca2ools.git;
    rev = "0032f7c85603f34b728a6f8bc6f25d7e4892432e";
    sha256 = "ae3c3918d60411ebf15faefb6dc94e3a98ab73cf751d8180c52f51b19ed64c09";
  };

  pythonPath = [ pythonPackages.boto pythonPackages.m2crypto pythonPackages.ssl ];

  meta = {
    homepage = http://open.eucalyptus.com/downloads;
    description = "Tools for interacting with Amazon EC2/S3-compatible cloud computing services";
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.linux;
  };
}
