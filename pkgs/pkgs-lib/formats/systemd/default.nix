{
  lib,
  pkgs,
  ini,
}:
let
  inherit (lib)
    warn
    ;
  inherit (lib.generators)
    mkValueStringDefault
    ;
in
{
  # As defined by systemd.syntax(7)
  #
  # null does not set any value, which allows for RFC42 modules to specify
  # optional config options.
  format =
    let
      mkValueString = mkValueStringDefault { };
      mkKeyValue = k: v: if v == null then "# ${k} is unset" else "${k} = ${mkValueString v}";

      rawFormat = ini {
        listsAsDuplicateKeys = true;
        inherit mkKeyValue;
      };
    in
    rawFormat
    // {
      generate =
        name: value:
        warn
          "Direct use of `pkgs.formats.systemd` has been deprecated, please use `pkgs.formats.systemd { }` instead."
          rawFormat.generate
          name
          value;
      __functor = self: { }: rawFormat;
    };
}
