{
  lib,
  pkgs,
}:
let
  inherit (lib)
    toJSON
    ;

  inherit (lib.types)
    serializableValueWith
    ;
in
{
  format =
    { }:
    {
      type = serializableValueWith { typeName = "ConfigObj mapping"; };

      generate =
        name: value:
        pkgs.runCommandLocal name
          {
            nativeBuildInputs = [
              (pkgs.python3.withPackages (ps: [ ps.configobj ]))
            ];

            valuesJSON = toJSON value;
            __structuredAttrs = true;
            strictDeps = true;
          }
          ''
            printf "%s" "$valuesJSON" | python3 ${./generate.py} > "$out"
          '';
    };
}
