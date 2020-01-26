{ buildPythonPackage
, fetchPypi
, lib
, recursivePthLoader
}:

buildPythonPackage rec {
  pname = "virtualenv";
  version = "16.7.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0d62c70883c0342d59c11d0ddac0d954d0431321a41ab20851facf2b222598f3";
  };

  # Doubt this is needed - FRidh 2017-07-07
  pythonPath = [ recursivePthLoader ];

  patches = [ ./virtualenv-change-prefix.patch ];

  # Tarball doesn't contain tests
  doCheck = false;

  meta = {
    description = "A tool to create isolated Python environments";
    homepage = http://www.virtualenv.org;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ goibhniu ];
  };
}