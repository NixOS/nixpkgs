{ lib, fetchPypi, buildPythonPackage
, traits, pyface, six
}:

buildPythonPackage rec {
  pname = "traitsui";
  version = "7.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ZkSz+PYColdgcC3IchuneM51lFBAk68UpIadI56GdPQ=";
  };

  propagatedBuildInputs = [ traits pyface six ];

  doCheck = false; # Needs X server

  meta = with lib; {
    description = "Traits-capable windowing framework";
    homepage = "https://github.com/enthought/traitsui";
    maintainers = with maintainers; [ knedlsepp ];
    license = licenses.bsdOriginal;
  };
}
