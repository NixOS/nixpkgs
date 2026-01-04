{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  tree-sitter,
}:

buildPythonPackage rec {
  pname = "tree-sitter-zeek";
  version = "0.2.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zeek";
    repo = "tree-sitter-zeek";
    tag = "v${version}";
    hash = "sha256-8ki1FRE1HSaG0180UWgEZxlmbOORvo3QlpLb9rMdmIQ=";
  };

  build-system = [ setuptools ];

  optional-dependencies = {
    core = [ tree-sitter ];
  };

  pythonImportsCheck = [ "tree_sitter_zeek" ];

  meta = {
    description = "Tree-sitter grammar for the Zeek scripting language";
    homepage = "https://github.com/zeek/tree-sitter-zeek";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      mdaniels5757
    ];
  };
}
