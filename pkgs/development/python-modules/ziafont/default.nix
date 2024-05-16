{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, pytestCheckHook
, nbval
}:

buildPythonPackage rec {
  pname = "ziafont";
  version = "0.8";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "cdelker";
    repo = pname;
    rev = version;
    hash = "sha256-C+dC+mNquDuj6RfJpiEbeuGZOIXcgSrTB4XM21reBPs=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
    nbval
  ];

  preCheck = "rm test/manyfonts.ipynb";  # Tries to download fonts

  pytestFlagsArray = [ "--nbval-lax" ];

  pythonImportsCheck = [ "ziafont" ];

  meta = with lib; {
    description = "Convert TTF/OTF font glyphs to SVG paths";
    homepage = "https://ziafont.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ sfrijters ];
  };
}
