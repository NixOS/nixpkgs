{ lib, fetchPypi, buildPythonPackage
, traits, pyface, six
}:

buildPythonPackage rec {
  pname = "traitsui";
  version = "7.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "77d9dc5830c4e7ab94f9225bc2f082430399d95c943f1616db41e83a94df38e5";
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
