{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  ziafont,
  pytestCheckHook,
  nbval,
  latex2mathml,
  writableTmpDirAsHomeHook,
  fetchurl,
}:
buildPythonPackage rec {
  pname = "ziamath";
  version = "0.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cdelker";
    repo = "ziamath";
    tag = version;
    hash = "sha256-4TSKxCCU4DP+CQKJoi3nBqstHVUb9ycz+JAlYctxGxY=";
  };

  build-system = [ setuptools ];

  dependencies = [ ziafont ];

  nativeCheckInputs = [
    pytestCheckHook
    nbval
    latex2mathml
    writableTmpDirAsHomeHook
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

  pythonImportsCheck = [ "ziamath" ];

  meta = {
    description = "Render MathML and LaTeX Math to SVG without Latex installation";
    homepage = "https://ziamath.readthedocs.io/en/latest/";
    changelog = "https://ziamath.readthedocs.io/en/latest/changes.html";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sfrijters ];
  };
}
