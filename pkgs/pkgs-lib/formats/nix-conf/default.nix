{
  pkgs,
  lib,
}:
let
  inherit (lib)
    boolToString
    concatStringsSep
    escape
    filterAttrs
    hasPrefix
    isBool
    isDerivation
    isFloat
    isInt
    isString
    mapAttrsToList
    optionalString
    strings
    types
    versionAtLeast
    ;
  inherit (lib.generators)
    toPretty
    ;
  inherit (types)
    attrsOf
    bool
    float
    int
    nullOr
    oneOf
    path
    str
    ;
in
{
  format =
    {
      package,
      version,
      extraOptions ? "",
      checkAllErrors ? true,
      checkConfig ? true,
    }:
    let
      isNixAtLeast = versionAtLeast version;
    in
    assert isNixAtLeast "2.2";
    {
      type =
        let
          atomType = nullOr (oneOf [
            bool
            int
            float
            str
            path
            types.package
          ]);
        in
        attrsOf atomType;
      generate =
        let
          # note that list type has been omitted here as the separator varies, see `nix.settings.*`
          mkValueString =
            v:
            if v == null then
              ""
            else if isInt v then
              toString v
            else if isBool v then
              boolToString v
            else if isFloat v then
              strings.floatToString v
            else if isDerivation v then
              toString v
            else if builtins.isPath v then
              toString v
            else if isString v then
              v
            else if strings.isConvertibleWithToString v then
              toString v
            else
              abort "The nix conf value: ${toPretty { } v} can not be encoded";

          mkKeyValue = k: v: "${escape [ "=" ] k} = ${mkValueString v}";

          mkKeyValuePairs = attrs: concatStringsSep "\n" (mapAttrsToList mkKeyValue attrs);

          isExtra = key: hasPrefix "extra-" key;
        in
        name: value:
        pkgs.writeTextFile {
          inherit name;
          # workaround for https://github.com/NixOS/nix/issues/9487
          # extra-* settings must come after their non-extra counterpart
          text = ''
            # WARNING: this file is generated from the nix.* options in
            # your NixOS configuration, typically
            # /etc/nixos/configuration.nix.  Do not edit it!
            ${mkKeyValuePairs (filterAttrs (key: _: !(isExtra key)) value)}
            ${mkKeyValuePairs (filterAttrs (key: _: isExtra key) value)}
            ${extraOptions}
          '';
          checkPhase = optionalString checkConfig (
            if pkgs.stdenv.hostPlatform != pkgs.stdenv.buildPlatform then
              ''
                echo "Ignoring validation for cross-compilation"
              ''
            else
              let
                showCommand = if isNixAtLeast "2.20pre" then "config show" else "show-config";
              in
              ''
                echo "Validating generated nix.conf"
                ln -s $out ./nix.conf
                set -e
                set +o pipefail
                NIX_CONF_DIR=$PWD \
                  ${package}/bin/nix ${showCommand} ${optionalString (isNixAtLeast "2.3pre") "--no-net"} \
                    ${optionalString (isNixAtLeast "2.4pre") "--option experimental-features nix-command"} \
                  |& sed -e 's/^warning:/error:/' \
                  | (! grep '${if checkAllErrors then "^error:" else "^error: unknown setting"}')
                set -o pipefail
              ''
          );
        };
    };
}
