{ stdenv, fetchgit, which, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "euca2ools-2.1.4";
  namePrefix = "";

  src = fetchgit {
    url = https://github.com/eucalyptus/euca2ools.git;
    rev = "19cb7eac34dd7efe3a56e4841b9692c03458bf3b";
    sha256 = "0grsgn5gbvk1hlfa8qx7ppz7iyfyi2pdhxy8njr8lm60w4amfiyq";
  };

  pythonPath = [ pythonPackages.boto pythonPackages.m2crypto ];

  meta = {
    homepage = http://open.eucalyptus.com/downloads;
    description = "Tools for interacting with Amazon EC2/S3-compatible cloud computing services";
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.linux;
  };
}
