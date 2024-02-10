# Takes a path to nixpkgs and a path to the json-encoded list of `pkgs/by-name` attributes.
# Returns a value containing information on all Nixpkgs attributes
# which is decoded on the Rust side.
# See ./eval.rs for the meaning of the returned values
{
  attrsPath,
  nixpkgsPath,
}:
let
  attrs = builtins.fromJSON (builtins.readFile attrsPath);

  # We need to check whether attributes are defined manually e.g. in
  # `all-packages.nix`, automatically by the `pkgs/by-name` overlay, or
  # neither. The only way to do so is to override `callPackage` and
  # `_internalCallByNamePackageFile` with our own version that adds this
  # information to the result, and then try to access it.
  overlay = final: prev: {

    # Adds information to each attribute about whether it's manually defined using `callPackage`
    callPackage = fn: args:
      addVariantInfo (prev.callPackage fn args) {
        # This is a manual definition of the attribute, and it's a callPackage, specifically a semantic callPackage
        ManualDefinition.is_semantic_call_package = true;
      };

    # Adds information to each attribute about whether it's automatically
    # defined by the `pkgs/by-name` overlay. This internal attribute is only
    # used by that overlay.
    # This overrides the above `callPackage` information (we don't need that
    # one, since `pkgs/by-name` always uses `callPackage` underneath.
    _internalCallByNamePackageFile = file:
      addVariantInfo (prev._internalCallByNamePackageFile file) {
        AutoDefinition = null;
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
      # so just don't return the value directly and treat it as if it wasn't a callPackage.
      value;

  pkgs = import nixpkgsPath {
    # Don't let the users home directory influence this result
    config = { };
    overlays = [ overlay ];
    # We check evaluation and callPackage only for x86_64-linux.
    # Not ideal, but hard to fix
    system = "x86_64-linux";
  };

  # See AttributeInfo in ./eval.rs for the meaning of this
  attrInfo = name: value: {
    location = builtins.unsafeGetAttrPos name pkgs;
    attribute_variant =
      if ! builtins.isAttrs value then
        { NonAttributeSet = null; }
      else
        {
          AttributeSet = {
            is_derivation = pkgs.lib.isDerivation value;
            definition_variant =
              if ! value ? _callPackageVariant then
                { ManualDefinition.is_semantic_call_package = false; }
              else
                value._callPackageVariant;
          };
        };
  };

  # Information on all attributes that are in pkgs/by-name.
  byNameAttrs = builtins.listToAttrs (map (name: {
    inherit name;
    value.ByName =
      if ! pkgs ? ${name} then
        { Missing = null; }
      else
        # Evaluation failures are not allowed, so don't try to catch them
        { Existing = attrInfo name pkgs.${name}; };
  }) attrs);

  # Information on all attributes that exist but are not in pkgs/by-name.
  # We need this to enforce pkgs/by-name for new packages
  nonByNameAttrs = builtins.mapAttrs (name: value:
    let
      # Packages outside `pkgs/by-name` often fail evaluation,
      # so we need to handle that
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
