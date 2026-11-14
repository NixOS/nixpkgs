{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  rustPlatform,
}:

buildPythonPackage (finalAttrs: {
  pname = "shaperglot";
  version = "1.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "shaperglot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VVxOkJ6a5UhQvSCswbgeRCLUEOzAbPhHuhJJAr1VvKA=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-WOIYg/QlWEk1StmudlPjpit/cKMkPtqLtf0BhPWQeg8=";
  };

  postPatch = ''
    cd shaperglot-py
  '';

  cargoRoot = "..";

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  pythonImportsCheck = [ "shaperglot" ];

  meta = {
    description = "Tool to test OpenType fonts for language support";
    homepage = "https://github.com/googlefonts/shaperglot";
    changelog = "https://github.com/googlefonts/shaperglot/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ danc86 ];
    mainProgram = "shaperglot";
  };
})
