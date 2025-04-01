{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  cargo,
  rustPlatform,
  rustc,
  setuptools,
  wheel,
  tree-sitter,
}:

let
  version = "0.23.1";

  src = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter-c-sharp";
    rev = "v${version}";
    hash = "sha256-weH0nyLpvVK/OpgvOjTuJdH2Hm4a1wVshHmhUdFq3XA=";
  };
in
buildPythonPackage {
  pname = "tree-sitter-c-sharp";
  inherit version src;
  pyproject = true;
  disabled = pythonOlder "3.9";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-IogdMRj1eHRLtdNFdGNInpEQAAbRpM248GqkY+Mgu10=";
  };

  build-system = [
    cargo
    rustPlatform.cargoSetupHook
    rustc
    setuptools
    wheel
  ];

  optional-dependencies = {
    core = [
      tree-sitter
    ];
  };

  pythonImportsCheck = [
    "tree_sitter_c_sharp"
  ];

  meta = {
    description = "C# Grammar for tree-sitter";
    homepage = "https://github.com/tree-sitter/tree-sitter-c-sharp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yzx9 ];
  };
}
