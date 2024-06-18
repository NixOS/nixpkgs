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
  pname = "tree-sitter-rust";
  version = "0.21.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter-rust";
    rev = "v${version}";
    hash = "sha256-4CTh6fKSV8TuMHLAfEKWsAeCqeCM2uo6hVmF5KWhyPY=";
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
  pythonImportsCheck = [ "tree_sitter_rust" ];

  meta = with lib; {
    description = "Rust grammar for tree-sitter";
    homepage = "https://github.com/tree-sitter/tree-sitter-rust";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
  };
}
