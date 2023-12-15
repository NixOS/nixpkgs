# Takes a path to nixpkgs and a path to the json-encoded list of attributes to check.
# Returns an attribute set containing information on each requested attribute.
# If the attribute is missing from Nixpkgs it's also missing from the result.
#
# The returned information is an attribute set with:
# - call_package_path: The <path> from `<attr> = callPackage <path> { ... }`,
#   or null if it's not defined as with callPackage, or if the <path> is not a path
# - is_derivation: The result of `lib.isDerivation <attr>`
{
  attrsPath,
  nixpkgsPath,
}:
let
  attrs = builtins.fromJSON (builtins.readFile attrsPath);

  # This overlay mocks callPackage to persist the path of the first argument
  callPackageOverlay = self: super: {
    callPackage = fn: args:
      let
        result = super.callPackage fn args;
        variantInfo._attributeVariant = {
          # These names are used by the deserializer on the Rust side
          CallPackage.path =
            if builtins.isPath fn then
              toString fn
            else
              null;
          CallPackage.empty_arg =
            args == { };
        };
      in
      if builtins.isAttrs result then
        # If this was the last overlay to be applied, we could just only return the `_callPackagePath`,
        # but that's not the case because stdenv has another overlays on top of user-provided ones.
        # So to not break the stdenv build we need to return the mostly proper result here
        result // variantInfo
      else
        # It's very rare that callPackage doesn't return an attribute set, but it can occur.
        variantInfo;

    _internalCallByNamePackageFile = file:
      let
        result = super._internalCallByNamePackageFile file;
        variantInfo._attributeVariant = {
          # This name is used by the deserializer on the Rust side
          AutoCalled = null;
        };
      in
      if builtins.isAttrs result then
        # If this was the last overlay to be applied, we could just only return the `_callPackagePath`,
        # but that's not the case because stdenv has another overlays on top of user-provided ones.
        # So to not break the stdenv build we need to return the mostly proper result here
        result // variantInfo
      else
        # It's very rare that callPackage doesn't return an attribute set, but it can occur.
        variantInfo;
  };

  pkgs = import nixpkgsPath {
    # Don't let the users home directory influence this result
    config = { };
    overlays = [ callPackageOverlay ];
  };

  attrInfo = attr:
    let
      value = pkgs.${attr};
    in
    {
    # These names are used by the deserializer on the Rust side
    variant = value._attributeVariant or { Other = null; };
    is_derivation = pkgs.lib.isDerivation value;
  };

  attrInfos = builtins.listToAttrs (map (name: {
    inherit name;
    value = attrInfo name;
  }) attrs);

in
# Filter out attributes not in Nixpkgs
builtins.intersectAttrs pkgs attrInfos
