{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  nbval,
  fetchurl,
}:
buildPythonPackage rec {
  pname = "ziafont";
  version = "0.9";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "cdelker";
    repo = "ziafont";
    rev = "refs/tags/${version}";
    hash = "sha256-S7IDL3ItP14/GrCUtSTT+JWuqRAY/Po0Kerq8mggDdg=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
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

  pytestFlagsArray = [ "--nbval-lax" ];

  pythonImportsCheck = [ "ziafont" ];

  meta = {
    description = "Convert TTF/OTF font glyphs to SVG paths";
    homepage = "https://ziafont.readthedocs.io/en/latest/";
    changelog = "https://github.com/cdelker/ziafont/blob/main/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sfrijters ];
  };
}
