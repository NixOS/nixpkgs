{ lib
, buildPythonPackage
, fetchFromGitHub
, cargo
, rustPlatform
, rustc
, setuptools
, wheel
, tree-sitter
}:

buildPythonPackage rec {
  pname = "tree-sitter-json";
  version = "0.21.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter-json";
    rev = "v${version}";
    hash = "sha256-waejAbS7MjrE7w03MPqvBRpEpqTcKc6RgKCVSYaDV1Y=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    # Upstream doesn't track a Cargo.lock file unfortunatly, but they barely
    # have rust dependencies so it doesn't cost us too much.
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  build-system = [
    cargo
    rustPlatform.cargoSetupHook
    rustc
    setuptools
    wheel
  ];

  passthru.optional-dependencies = {
    core = [
      tree-sitter
    ];
  };

  # There are no tests
  doCheck = false;
  pythonImportsCheck = [ "tree_sitter_json" ];

  meta = with lib; {
    description = "JSON grammar for tree-sitter";
    homepage = "https://github.com/tree-sitter/tree-sitter-json";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
  };
}
