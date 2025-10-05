{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  tree-sitter-sql,

  #optional-dependencies
  tree-sitter,
}:
buildPythonPackage rec {
  pname = "tree-sitter-sql";
  version = "0.3.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DerekStride";
    repo = "tree-sitter-sql";
    tag = "v${version}";
    hash = "sha256-vPPlDdLkenLG8uH26fzMOS3oxClCLSIKa6zhmDbnC/A=";
  };

  postUnpack = ''
    cp -rf ${tree-sitter-sql.passthru.parsers}/* $sourceRoot
  '';

  build-system = [
    setuptools
  ];

  passthru = {
    # As mentioned in https://github.com/DerekStride/tree-sitter-sql README
    # generated tree sitter parser files necessary for compilation
    # are separately distributed on the gh-pages branch
    parsers = fetchFromGitHub {
      owner = "DerekStride";
      repo = "tree-sitter-sql";
      rev = "9853b887c5e4309de273922b681cc7bc09e30c78/gh-pages";
      hash = "sha256-p60nphbSN+O5fOlL06nw0qgQFpmvoNCTmLzDvUC/JGs=";
    };
  };

  optional-dependencies = {
    core = [
      tree-sitter
    ];
  };

  pythonImportsCheck = [ "tree_sitter_sql" ];

  meta = {
    description = "Sql grammar for tree-sitter";
    homepage = "https://github.com/DerekStride/tree-sitter-sql";
    changelog = "https://github.com/DerekStride/tree-sitter-sql/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pcboy ];
  };
}
