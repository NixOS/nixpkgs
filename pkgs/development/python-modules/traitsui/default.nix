{ lib, fetchPypi, buildPythonPackage
, traits, pyface, six
}:

buildPythonPackage rec {
  pname = "traitsui";
  version = "7.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "74fb4db848ac1343241fa4dc5d9bf3fab561f309826c602e8a3568309df91fe3";
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
