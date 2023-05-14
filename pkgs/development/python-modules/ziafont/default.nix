{ lib
, buildPythonPackage
, pythonOlder
, fetchFromBitbucket
, pytestCheckHook
, nbval
}:

buildPythonPackage rec {
  pname = "ziafont";
  version = "0.5";

  disabled = pythonOlder "3.8";

  src = fetchFromBitbucket {
    owner = "cdelker";
    repo = pname;
    rev = version;
    hash = "sha256-mTQ2yRG+E2nZ2g9eSg+XTzK8A1EgKsRfbvNO3CdYeLg=";
  };

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
