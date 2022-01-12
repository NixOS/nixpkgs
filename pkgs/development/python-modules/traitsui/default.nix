{ lib, fetchPypi, buildPythonPackage
, traits, pyface, six
}:

buildPythonPackage rec {
  pname = "traitsui";
  version = "7.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dfc39015faf0591f9927e3d4d22bd95a16d49c85db30e60acd4ba7b85c7c5d5b";
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
