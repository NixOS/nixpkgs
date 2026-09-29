{
  lib,
  pkgs,
}:
let
  inherit (lib)
    optionalString
    ;
  inherit (lib.generators)
    mkLuaInline
    toLua
    ;
  inherit (lib.types)
    attrsOf
    bool
    float
    int
    listOf
    luaInline
    nullOr
    oneOf
    path
    str
    ;
in
{
  format =
    {
      asBindings ? false,
      multiline ? true,
      columnWidth ? 100,
      indentWidth ? 2,
      indentUsingTabs ? false,
    }:
    {
      type =
        let
          valueType =
            nullOr (oneOf [
              bool
              float
              int
              path
              str
              luaInline
              (attrsOf valueType)
              (listOf valueType)
            ])
            // {
              description = "lua value";
              descriptionClass = "noun";
            };
        in
        if asBindings then attrsOf valueType else valueType;
      generate =
        name: value:
        pkgs.callPackage (
          { runCommand, stylua }:
          runCommand name
            {
              nativeBuildInputs = [ stylua ];
              inherit columnWidth;
              inherit indentWidth;
              indentType = if indentUsingTabs then "Tabs" else "Spaces";
              value = toLua { inherit asBindings multiline; } value;
              preferLocalBuild = true;
              __structuredAttrs = true;
            }
            ''
              ${optionalString (!asBindings) ''
                echo -n 'return ' >> $out
              ''}
              printf "%s" "$value" >> $out
              stylua \
                --no-editorconfig \
                --line-endings Unix \
                --column-width $columnWidth \
                --indent-width $indentWidth \
                --indent-type $indentType \
                $out
            ''
        ) { };
      # Alias for mkLuaInline
      lib.mkRaw = mkLuaInline;
    };
}
