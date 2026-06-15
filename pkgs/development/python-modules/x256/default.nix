{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "x256";
  version = "0.0.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "00g02b9a6jsl377xb5fmxvkjff3lalw21n430a4zalqyv76dnmgq";
  };

  build-system = [ setuptools ];

  doCheck = false;

  meta = {
    description = "Find the nearest xterm 256 color index for an RGB";
    homepage = "https://github.com/magarcia/python-x256";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
