{ lib
, fetchPypi
, buildPythonPackage
, traits
, pyface
, pythonOlder
}:

buildPythonPackage rec {
  pname = "traitsui";
  version = "7.4.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IEcb8znD7ed/BrL6l76Qrj0Wbr78zBZ7y9oifHWxZj8=";
  };

  propagatedBuildInputs = [
    traits
    pyface
  ];

  # Needs X server
  doCheck = false;

  pythonImportsCheck = [
    "traitsui"
  ];

  meta = with lib; {
    description = "Traits-capable windowing framework";
    homepage = "https://github.com/enthought/traitsui";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ knedlsepp ];
  };
}
