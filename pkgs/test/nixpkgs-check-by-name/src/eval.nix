# Takes a path to nixpkgs and a path to the json-encoded list of attributes to check.
# Returns an value containing information on each requested attribute,
# which is decoded on the Rust side.
# See ./eval.rs for the meaning of the returned values
{
  attrsPath,
  nixpkgsPath,
}:
let
  attrs = builtins.fromJSON (builtins.readFile attrsPath);

  nixpkgsPathLength = builtins.stringLength (toString nixpkgsPath) + 1;
  removeNixpkgsPrefix = builtins.substring nixpkgsPathLength (-1);

  # We need access to the `callPackage` arguments of each attribute.
  # The only way to do so is to override `callPackage` with our own version that adds this information to the result,
  # and then try to access this information.
  overlay = final: prev: {

    # Information for attributes defined using `callPackage`
    callPackage = fn: args:
      addVariantInfo (prev.callPackage fn args) {
        Manual = {
          path =
            if builtins.isPath fn then
              removeNixpkgsPrefix (toString fn)
            else
              null;
          empty_arg =
            args == { };
        };
      };

    # Information for attributes that are auto-called from pkgs/by-name.
    # This internal attribute is only used by pkgs/by-name
    _internalCallByNamePackageFile = file:
      addVariantInfo (prev._internalCallByNamePackageFile file) {
        Auto = null;
      };

  };

  # We can't just replace attribute values with their info in the overlay,
  # because attributes can depend on other attributes, so this would break evaluation.
  addVariantInfo = value: variant:
    if builtins.isAttrs value then
      value // {
        _callPackageVariant = variant;
      }
    else
      # It's very rare that callPackage doesn't return an attribute set, but it can occur.
      # In such a case we can't really return anything sensible that would include the info,
      # so just don't return the info and let the consumer handle it.
      value;

  pkgs = import nixpkgsPath {
    # Don't let the users home directory influence this result
    config = { };
    overlays = [ overlay ];
    # We check evaluation and callPackage only for x86_64-linux.
    # Not ideal, but hard to fix
    system = "x86_64-linux";
  };

  attrInfo = name: value:
    if ! builtins.isAttrs value then
      {
        NonAttributeSet = null;
      }
    else if ! value ? _callPackageVariant then
      {
        NonCallPackage = null;
      }
    else
      {
        CallPackage = {
          call_package_variant = value._callPackageVariant;
          is_derivation = pkgs.lib.isDerivation value;
        };
      };

  byNameAttrs = builtins.listToAttrs (map (name: {
    inherit name;
    value.ByName =
      if ! pkgs ? ${name} then
        { Missing = null; }
      else
        { Existing = attrInfo name pkgs.${name}; };
  }) attrs);

  # Information on all attributes that exist but are not in pkgs/by-name.
  # We need this to enforce pkgs/by-name for new packages
  nonByNameAttrs = builtins.mapAttrs (name: value:
    let
      output = attrInfo name value;
      result = builtins.tryEval (builtins.deepSeq output null);
    in
    {
      NonByName =
        if result.success then
          { EvalSuccess = output; }
        else
          { EvalFailure = null; };
    }
  ) (builtins.removeAttrs pkgs attrs);

  # All attributes
  attributes = byNameAttrs // nonByNameAttrs;
in
# We output them in the form [ [ <name> <value> ] ]` such that the Rust side
# doesn't need to sort them again to get deterministic behavior (good for testing)
map (name: [
  name
  attributes.${name}
]) (builtins.attrNames attributes)
