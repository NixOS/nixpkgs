{
  lib,
  buildPythonPackage,
  fetchPypi,
  fonttools,
  uharfbuzz,
}:

buildPythonPackage rec {
  pname = "vharfbuzz";
  version = "0.3.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zFVw8Nxh7cRJNk/S7D3uiIGShBMiZ/JeuSdX4hN94kc=";
  };

  propagatedBuildInputs = [
    fonttools
    uharfbuzz
  ];

  # Package has no tests.
  doCheck = false;
  pythonImportsCheck = [ "vharfbuzz" ];

  meta = with lib; {
    description = "Utility for removing hinting data from TrueType and OpenType fonts";
    homepage = "https://github.com/source-foundry/dehinter";
    license = licenses.asl20;
    maintainers = with maintainers; [ danc86 ];
  };
}
