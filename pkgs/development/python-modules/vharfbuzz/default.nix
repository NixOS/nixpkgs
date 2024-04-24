{ lib
, buildPythonPackage
, fetchPypi
, fonttools
, pythonImportsCheckHook
, uharfbuzz
}:

buildPythonPackage rec {
  pname = "vharfbuzz";
  version = "0.3.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bBKmVvLuc/CtQF+TSri8ngglnj4QCh77FV+JHPzsFAI=";
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

