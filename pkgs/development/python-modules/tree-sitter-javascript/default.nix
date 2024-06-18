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
  pname = "tree-sitter-javascript";
  version = "0.21.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter-javascript";
    rev = "v${version}";
    hash = "sha256-jsdY9Pd9WqZuBYtk088mx1bRQadC6D2/tGGVY+ZZ0J4=";
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
  pythonImportsCheck = [ "tree_sitter_javascript" ];

  meta = with lib; {
    description = "JavaScript and JSX grammar for tree-sitter";
    homepage = "https://github.com/tree-sitter/tree-sitter-javascript";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
  };
}
