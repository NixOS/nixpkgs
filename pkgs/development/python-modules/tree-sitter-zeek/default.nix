{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  tree-sitter,
}:

buildPythonPackage rec {
  pname = "tree-sitter-zeek";
  version = "0.2.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zeek";
    repo = "tree-sitter-zeek";
    tag = "v${version}";
    hash = "sha256-gxBHNhldyzAQdsMb5QwPAB8z+k/hFAS6SrSQmAAfi9Q=";
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
