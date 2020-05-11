{ buildPythonPackage
, fetchPypi
, lib
, recursivePthLoader
}:

buildPythonPackage rec {
  pname = "virtualenv";
  version = "16.7.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e88fdcb08b0ecb11da97868f463dd06275923f50d87f4b9c8b2fc0994eec40f4";
  };

  # Doubt this is needed - FRidh 2017-07-07
  pythonPath = [ recursivePthLoader ];

  patches = [ ./virtualenv-change-prefix.patch ];

  # Tarball doesn't contain tests
  doCheck = false;

  meta = {
    description = "A tool to create isolated Python environments";
    homepage = "http://www.virtualenv.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ goibhniu ];
  };
}
