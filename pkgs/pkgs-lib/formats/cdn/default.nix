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
  /*
    dzikoysk's CDN format, see https://github.com/dzikoysk/cdn

    The result is almost identical to YAML when there are no nested properties,
    but differs enough in the other case to warrant a separate format.
    (see https://github.com/dzikoysk/cdn#supported-formats)

    Currently used by Panda, Reposilite, and FunnyGuilds (as per the repo's readme).
  */
  format =
    { }:
    {
      type = serializableValueWith { typeName = "CDN"; };

      generate =
        name: value:
        pkgs.callPackage (
          { runCommand, json2cdn }:
          runCommand name
            {
              nativeBuildInputs = [ json2cdn ];
              value = toJSON value;
              preferLocalBuild = true;
              __structuredAttrs = true;
            }
            ''
              valuePath="$TMPDIR/value"
              printf "%s" "$value" > "$valuePath"
              json2cdn "$valuePath" > $out
            ''
        ) { };
    };
}
