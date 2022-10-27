{ lib
, fetchPypi
, buildPythonPackage
, traits
, pyface
, pythonOlder
}:

buildPythonPackage rec {
  pname = "traitsui";
  version = "7.4.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TFs9Oq6qvR7IGgqMQPnM0o+oy51k7RORfJkNF0ZU+h0=";
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
