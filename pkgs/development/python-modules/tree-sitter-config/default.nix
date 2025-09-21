# <<< TODO: could this get upstreamed to <https://github.com/tree-sitter/py-tree-sitter>? >>>
{
  pkgs, # <<<
  buildPythonPackage,
  datamodel-code-generator,
  lib,
  pydantic,
  runCommand,
  hatchling,
  symlinkJoin,
  writeTextDir,
}:
let
  version = "0.1.0"; # <<< TODO>>>
in
buildPythonPackage {
  inherit version;
  pname = "tree-sitter-config";
  pyproject = true;
  build-system = [ hatchling ];

  src = symlinkJoin {
    name = "tree-sitter-config-source";
    paths = [
      (writeTextDir "pyproject.toml"
        # toml
        ''
          [build-system]
          requires = ["hatchling >= 1.26"]
          build-backend = "hatchling.build"

          [project]
          name = "tree_sitter_config"
          version = "${version}"
        ''
      )
      (runCommand "tree_sitter_config/__init__.py"
        {
          nativeBuildInputs = [
            datamodel-code-generator
          ];
        }
        ''
          mkdir -p $out/tree_sitter_config
          datamodel-codegen \
            --input ${pkgs.tree-sitter}/config.schema.json \
            --input-file-type jsonschema \
            --output-model-type pydantic_v2.BaseModel \
            --class-name TreeSitterConfig \
            > $out/tree_sitter_config/__init__.py
        ''
      )
    ];
  };

  pythonImportsCheck = [ "tree_sitter_config" ];

  dependencies = [ pydantic ] ++ pydantic.optional-dependencies.email;

  meta = {
    description = "Python types for tree-sitter.json";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jfly ];
  };
}
