{ lib
, buildPythonPackage
, fetchPypi
, fonttools
, pythonImportsCheckHook
, uharfbuzz
}:

buildPythonPackage rec {
  pname = "vharfbuzz";
  version = "0.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uDX2fYqxV4wmAAIMfA3dBohWmq1N0VurSTEFOjSRpmY=";
  };

  propagatedBuildInputs = [
    fonttools
    uharfbuzz
  ];
  nativeBuildInputs = [
    pythonImportsCheckHook
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

