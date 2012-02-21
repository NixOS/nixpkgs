{ stdenv, fetchurl, which, pythonPackages }:

stdenv.mkDerivation rec {
  name = "euca2ools-1.3.1";
  namePrefix = "";

  src = fetchurl {
    url = "http://eucalyptussoftware.com/downloads/releases/${name}.tar.gz";
    sha256 = "1k4hakbxqsv2gzcdrf6dbyrpnajcan9yilddhs47cg7lgqw7b41f";
  };

  makeFlags = "PREFIX=$(out)";

  buildInputs = [ which pythonPackages.python pythonPackages.wrapPython ];

  # We need boto 1.9 for now.  See https://bugs.launchpad.net/euca2ools/devel/+bug/623888
  pythonPath = [ pythonPackages.setuptools pythonPackages.boto_1_9 pythonPackages.m2crypto ];

  preBuild =
    ''
      substituteInPlace Makefile --replace "-o root" ""
    
      substituteInPlace euca2ools/Makefile \
        --replace 'python setup.py install' "python setup.py install --prefix=$out"
    '';

  postInstall = "wrapPythonPrograms";

  meta = {
    homepage = http://open.eucalyptus.com/downloads;
    description = "Tools for interacting with Amazon EC2/S3-compatible cloud computing services";
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.linux;
  };
}
