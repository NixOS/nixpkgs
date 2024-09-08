{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  ziafont,
  pytestCheckHook,
  nbval,
  latex2mathml,
  fetchurl,
}:
buildPythonPackage rec {
  pname = "ziamath";
  version = "0.11";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "cdelker";
    repo = "ziamath";
    rev = "refs/tags/${version}";
    hash = "sha256-DLpbidQEeQVKxGCbS2jeeCvmVK9ElDIDQMj5bh/x7/Q=";
  };

  build-system = [ setuptools ];

  dependencies = [ ziafont ];

  nativeCheckInputs = [
    pytestCheckHook
    nbval
    latex2mathml
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

  pythonImportsCheck = [ "ziamath" ];

  meta = {
    description = "Render MathML and LaTeX Math to SVG without Latex installation";
    homepage = "https://ziamath.readthedocs.io/en/latest/";
    changelog = "https://ziamath.readthedocs.io/en/latest/changes.html";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sfrijters ];
  };
}
