{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "x256";
  version = "0.0.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "00g02b9a6jsl377xb5fmxvkjff3lalw21n430a4zalqyv76dnmgq";
  };

  doCheck = false;

  meta = with lib; {
    description = "Find the nearest xterm 256 color index for an RGB";
    homepage = "https://github.com/magarcia/python-x256";
    license = licenses.mit;
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}
