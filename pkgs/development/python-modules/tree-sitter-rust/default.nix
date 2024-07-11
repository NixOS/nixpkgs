{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
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

  build-system = [
    setuptools
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
