{ lib, fetchPypi, buildPythonPackage
, traits, pyface, six
}:

buildPythonPackage rec {
  pname = "traitsui";
  version = "7.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e569f359a58e4567b14265abe89b3de4b0f95bbbf8f491a9a7d45219628735ec";
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
