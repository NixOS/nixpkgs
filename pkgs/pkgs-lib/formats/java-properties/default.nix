{ lib, pkgs }:
{
  javaProperties = { comment ? "Generated with Nix" }: {
    type = lib.types.attrsOf lib.types.str;

    generate = name: value:
      pkgs.runCommandLocal name
        {
          # Requirements
          # ============
          #
          #  1. Strings in Nix carry over to the same
          #     strings in Java => need proper escapes
          #  2. Generate files quickly
          #      - A JVM would have to match the app's
          #        JVM to avoid build closure bloat
          #      - Even then, JVM startup would slow
          #        down config generation.
          #
          #
          # Implementation
          # ==============
          #
          # Escaping has two steps
          #
          # 1. jq
          #    Escape known separators, in order not
          #    to break up the keys and values.
          #    This handles typical whitespace correctly,
          #    but may produce garbage for other control
          #    characters.
          #
          # 2. iconv
          #    Escape >ascii code points to java escapes,
          #    as .properties files are supposed to be
          #    encoded in ISO 8859-1. It's an old format.
          #    UTF-8 behavior may exist in some apps and
          #    libraries, but we can't rely on this in
          #    general.

          passAsFile = [ "value" ];
          value = builtins.toJSON value;
          nativeBuildInputs = [
            pkgs.jq
            pkgs.libiconvReal
          ];

          jqCode =
            let
              main = ''
                to_entries
                  | .[]
                  | "\(
                      .key
                      | ${commonEscapes}
                      | gsub(" "; "\\ ")
                      | gsub("="; "\\=")
                    ) = \(
                      .value
                      | ${commonEscapes}
                      | gsub("^ "; "\\ ")
                      | gsub("\\n "; "\n\\ ")
                    )"
              '';
              # Most escapes are equal for both keys and values.
              commonEscapes = ''
                gsub("\\\\"; "\\\\")
                | gsub("\\n"; "\\n\\\n")
                | gsub("#"; "\\#")
                | gsub("!"; "\\!")
                | gsub("\\t"; "\\t")
                | gsub("\r"; "\\r")
              '';
            in
            main;

          inputEncoding = "UTF-8";

          inherit comment;

        } ''
        (
          echo "$comment" | while read -r ln; do echo "# $ln"; done
          echo
          jq -r --arg hash '#' "$jqCode" "$valuePath" \
            | iconv --from-code "$inputEncoding" --to-code JAVA \
        ) > "$out"
      '';
  };
}
