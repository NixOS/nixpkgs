{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  nbval,
  writableTmpDirAsHomeHook,
  fetchurl,
}:
buildPythonPackage rec {
  pname = "ziafont";
  version = "0.11";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "cdelker";
    repo = "ziafont";
    tag = version;
    hash = "sha256-KjJ+/Yo5mLV6m7Y0eIGHECH0RvdI+eaFTccDmytNTKI=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
    nbval
  ];

  preCheck =
    let
      # The test notebooks try to download font files, unless they already exist in the test directory,
      # so we prepare them in advance.
      checkFonts = lib.map fetchurl (import ./checkfonts.nix);
      copyFontCmd = font: "cp ${font} test/${lib.last (lib.splitString "/" font.url)}\n";
    in
    lib.concatMapStrings copyFontCmd checkFonts;

  pytestFlags = [ "--nbval-lax" ];

  pythonImportsCheck = [ "ziafont" ];

  meta = {
    description = "Convert TTF/OTF font glyphs to SVG paths";
    homepage = "https://ziafont.readthedocs.io/en/latest/";
    changelog = "https://github.com/cdelker/ziafont/blob/main/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sfrijters ];
  };
}
