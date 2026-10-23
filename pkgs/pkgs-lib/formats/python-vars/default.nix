{
  pkgs,
  lib,
}:
{
  # Outputs a succession of Python variable assignments
  # Useful for many Django-based services
  format =
    { }:
    {
      type = lib.types.attrsOf (
        lib.types.serializableValueWith {
          typeName = "Python";
        }
      );

      lib = {
        mkRaw = value: {
          inherit value;
          _type = "raw";
        };
      };

      generate =
        name: value:
        pkgs.callPackage (
          {
            runCommand,
            python3,
            black,
          }:
          runCommand name
            {
              nativeBuildInputs = [
                python3
                black
              ];
              imports = value._imports or [ ];
              # value must be an attrset, type would verify that,
              # otherwise removeAttrs will fail.
              value = removeAttrs value [ "_imports" ];
              pythonGen = pkgs.writeText "pythonGen" ''
                import ast
                import json
                import os

                def gen_ast_node(value: any) -> ast.expr:
                    if type(value) is list:
                        return ast.List(elts=[gen_ast_node(x) for x in value])
                    elif type(value) is dict:
                        if value.get("_type") == "raw":
                            return ast.parse(value["value"], mode="eval").body
                        else:
                            return ast.Dict(
                                keys=[ast.Constant(k) for k in value],
                                values=[gen_ast_node(v) for v in value.values()],
                            )
                    else:
                        return ast.Constant(value)


                tree = ast.Module(body=[], type_ignores=[])

                with open(os.environ["NIX_ATTRS_JSON_FILE"], "r") as f:
                    attrs = json.load(f)

                    if attrs["imports"] is not None:
                        for i in attrs["imports"]:
                            tree.body.append(ast.parse(f"import {i}").body[0])

                    for key, val in attrs["value"].items():
                        tree.body.append(ast.Assign(
                            targets=[ast.Name(id=key, ctx=ast.Store())],
                            value=gen_ast_node(val),
                        ))

                ast.fix_missing_locations(tree)

                print(ast.unparse(tree))

              '';
              preferLocalBuild = true;
              __structuredAttrs = true;
            }
            ''
              python3 "$pythonGen" > $out
              black $out
            ''
        ) { };
    };
}
