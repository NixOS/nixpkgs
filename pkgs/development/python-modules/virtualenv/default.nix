{ buildPythonPackage
, fetchPypi
, lib
, recursivePthLoader
}:

buildPythonPackage rec {
  pname = "virtualenv";
  version = "16.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f899fafcd92e1150f40c8215328be38ff24b519cd95357fa6e78e006c7638208";
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