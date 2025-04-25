/**
  Build the `systemd.functions` library (where `systemd` is the package)
*/
{ lib, systemd }:
let
  inherit (lib)
    concatMapStringsSep
    isDerivation
    isFloat
    isInt
    isPath
    isString
    replaceStrings
    ;
  inherit (builtins)
    toJSON
    ;

  /**
    Quotes an argument for use in `Exec*` service lines.
    Additionally we escape `%` to disallow expansion of `%` specifiers. Any lone `;`
    in the input will be turned into `";"` and thus lose its special meaning.
    Every `$` is escaped to `$$`, this makes it unnecessary to disable environment
    substitution for the directive.
  */
  escapeSystemdExecArg =
    arg:
    let
      s =
        if isPath arg then
          "${arg}"
        else if isString arg then
          arg
        else if isInt arg || isFloat arg || isDerivation arg then
          toString arg
        else
          throw "escapeSystemdExecArg only allows strings, paths, numbers and derivations";
    in
    # systemd accepts "-quoted strings with escape sequences, toJSON produces
    # a subset of these.
    replaceStrings [ "%" "$" ] [ "%%" "$$" ] (toJSON s);

  /**
    Quotes a list of arguments into a single string for use in a Exec* line.
  */
  escapeSystemdExecArgs = concatMapStringsSep " " escapeSystemdExecArg;
in
# Instead of requiring v2, we can make this library conditional on the version as needed.
assert systemd.interfaceVersion == 2;
{
  inherit
    escapeSystemdExecArg
    escapeSystemdExecArgs
    ;
}
