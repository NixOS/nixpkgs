{ lib, pkgs }:
let
  inherit (lib) types;
  inherit (types)
    attrsOf
    oneOf
    coercedTo
    str
    bool
    int
    float
    package
    ;
in
{
  javaProperties =
    {
      comment ? "Generated with Nix",
      boolToString ? lib.boolToString,
    }:
    {

      # Design note:
      # A nested representation of inevitably leads to bad UX:
      # 1. keys like "a.b" must be disallowed, or
      #    the addition of options in a freeformType module
      #    become breaking changes
      # 2. adding a value for "a" after "a"."b" was already
      #    defined leads to a somewhat hard to understand
      #    Nix error, because that's not something you can
      #    do with attrset syntax. Workaround: "a"."", but
      #    that's too little too late. Another workaround:
      #    mkMerge [ { a = ...; } { a.b = ...; } ].
      #
      # Choosing a non-nested representation does mean that
      # we sacrifice the ability to override at the (conceptual)
      # hierarchical levels, _if_ an application exhibits those.
      #
      # Some apps just use periods instead of spaces in an odd
      # mix of attempted categorization and natural language,
      # with no meaningful hierarchy.
      #
      # We _can_ choose to support hierarchical config files
      # via nested attrsets, but the module author should
      # make sure that problem (2) does not occur.
      type =
        let
          elemType =
            oneOf ([
              # `package` isn't generalized to `path` because path values
              # are ambiguous. Are they host path strings (toString /foo/bar)
              # or should they be added to the store? ("${/foo/bar}")
              # The user must decide.
              (coercedTo package toString str)

              (coercedTo bool boolToString str)
              (coercedTo int toString str)
              (coercedTo float toString str)
            ])
            // {
              description = "string, package, bool, int or float";
            };
        in
        attrsOf elemType;

      generate =
        name: value:
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

          }
          ''
            (
              echo "$comment" | while read -r ln; do echo "# $ln"; done
              echo
              jq -r --arg hash '#' "$jqCode" "$valuePath" \
                | iconv --from-code "$inputEncoding" --to-code JAVA \
            ) > "$out"
          '';
    };
}
