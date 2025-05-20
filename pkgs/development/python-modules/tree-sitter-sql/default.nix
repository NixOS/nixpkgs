{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchurl,
  setuptools,
  tree-sitter,
  cython,
}:
let
  parsers = fetchurl {
    url = "https://github.com/derekstride/tree-sitter-sql/archive/gh-pages.tar.gz";
    sha256 = "sha256-/Kwc9aausn88MYRvv05bhI0Ftvce7nDj7zBaB3EBUZU=";
  };
in
buildPythonPackage rec {
  pname = "tree-sitter-sql";
  version = "0.3.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DerekStride";
    repo = "tree-sitter-sql";
    tag = "v${version}";
    hash = "sha256-8gdbbz187sV8I+PJHubFyyQwGUqvo05Yw1DX7rOK4DI=";
  };

  postUnpack = ''
    tar -xzf ${parsers} --strip-components=1 -C $sourceRoot
  '';

  build-system = [
    setuptools
  ];

  optional-dependencies = {
    core = [
      tree-sitter
    ];
  };

  pythonImportsCheck = [ "tree_sitter_sql" ];

  meta = with lib; {
    description = "sql grammar for tree-sitter";
    homepage = "https://github.com/DerekStride/tree-sitter-sql";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
  };
}
