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
    url = "https://github.com/derekstride/tree-sitter-sql/archive/9853b887c5e4309de273922b681cc7bc09e30c78/gh-pages.tar.gz";
    sha256 = "sha256-++RN1Pwn/Dl99gSf4eU+8Nlu8FXCQtNzP4F734DA6ak=";
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
