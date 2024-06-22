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
  pname = "tree-sitter-python";
  version = "0.21.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter-python";
    rev = "v${version}";
    hash = "sha256-ZQ949GbgzZ/W667J+ekvQbs4bGnbDO+IWejivhxPZXM=";
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
  pythonImportsCheck = [ "tree_sitter_python" ];

  meta = with lib; {
    description = "Python grammar for tree-sitter";
    homepage = "https://github.com/tree-sitter/tree-sitter-python";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
  };
}
