{ buildPythonPackage
, fetchPypi
, lib
, recursivePthLoader
}:

buildPythonPackage rec {
  pname = "virtualenv";
  version = "15.0.3";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6d9c760d3fc5fa0894b0f99b9de82a4647e1164f0b700a7f99055034bf548b1d";
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