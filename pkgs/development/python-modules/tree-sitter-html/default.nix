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
  pname = "tree-sitter-html";
  version = "0.20.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter-html";
    rev = "v${version}";
    hash = "sha256-sHy3fVWemJod18HCQ8zBC/LpeCCPH0nzhI1wrkCg8nw=";
  };

  cargoDeps = rustPlatform.importCargoLock {
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
  pythonImportsCheck = [ "tree_sitter_html" ];

  meta = with lib; {
    description = "HTML grammar for tree-sitter";
    homepage = "https://github.com/tree-sitter/tree-sitter-html";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
  };
}
