{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  rustPlatform,
}:

buildPythonPackage (finalAttrs: {
  pname = "shaperglot";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "shaperglot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g8f8Q2DvYNvm8i6S+9K/jhhUiuGw366dht0Khx3/INg=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-ivl3Zq0HRn4yP9JKfbjSaaERjbQ3SAEWhHk6toFp8dE=";
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
