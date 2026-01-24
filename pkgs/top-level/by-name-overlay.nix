# This file turns the pkgs/by-name directory (see its README.md for more info) into an overlay that adds all the defined packages.
# No validity checks are done here,
# instead this file is optimised for performance,
# and validity checks are done by CI on PRs.

# Type: Path -> Overlay
baseDirectory:
let
  # Because of Nix's import-value cache, importing lib is free
  lib = import ../../lib;

  inherit (builtins)
    readDir
    ;

  inherit (lib.attrsets)
    mapAttrs
    mapAttrsToList
    mergeAttrsList
    ;

  # Folder ranges that should have enhanced defaults applied
  # Each range is { from = "aa"; to = "az"; } (inclusive)
  # Packages in these ranges get structuredAttrsByDefault, enableParallelBuilding
  # and strictDeps unless explicitly set to false
  # Starting with underscore-prefixed directories which have minimal reverse deps
  enhancedDefaultRanges = [
    {
      from = "_0";
      to = "a-";
    }
  ];

  # Check if a shard falls within any of the enhanced default ranges
  shardInRange =
    shard:
    let
      inSingleRange = range: shard >= range.from && shard <= range.to;
    in
    builtins.any inSingleRange enhancedDefaultRanges;

  # Package files for a single shard
  # Type: String -> String -> AttrsOf Path
  namesForShard =
    shard: type:
    if type != "directory" then
      # Ignore all non-directories. Technically only README.md is allowed as a file in the base directory, so we could alternatively:
      # - Assume that README.md is the only file and change the condition to `shard == "README.md"` for a minor performance improvement.
      #   This would however cause very poor error messages if there's other files.
      # - Ensure that README.md is the only file, throwing a better error message if that's not the case.
      #   However this would make for a poor code architecture, because one type of error would have to be duplicated in the validity checks and here.
      # Additionally in either of those alternatives, we would have to duplicate the hardcoding of "README.md"
      { }
    else
      mapAttrs (name: _: baseDirectory + "/${shard}/${name}/package.nix") (
        readDir (baseDirectory + "/${shard}")
      );

  # Set of shards that should have enhanced defaults
  enhancedShards = lib.genAttrs (builtins.filter shardInRange (
    builtins.attrNames (readDir baseDirectory)
  )) (_: true);

  # The attribute set mapping names to the package files defining them
  # This is defined up here in order to allow reuse of the value (it's kind of expensive to compute)
  # if the overlay has to be applied multiple times
  packageFiles = mergeAttrsList (mapAttrsToList namesForShard (readDir baseDirectory));

  # Enhanced defaults to apply
  enhancedDefaults = {
    __structuredAttrs = true;
    enableParallelBuilding = true;
    strictDeps = true;
  };

in
self: super:
{
  # This attribute is necessary to allow CI to ensure that all packages defined in `pkgs/by-name`
  # don't have an overriding definition in `all-packages.nix` with an empty (`{ }`) second `callPackage` argument.
  # It achieves that with an overlay that modifies both `callPackage` and this attribute to signal whether `callPackage` is used
  # and whether it's defined by this file here or `all-packages.nix`.
  # TODO: This can be removed once `pkgs/by-name` can handle custom `callPackage` arguments without `all-packages.nix` (or any other way of achieving the same result).
  # Because at that point the code in ./stage.nix can be changed to not allow definitions in `all-packages.nix` to override ones from `pkgs/by-name` anymore and throw an error if that happens instead.
  _internalCallByNamePackageFile =
    file:
    let
      result = self.callPackage file { };
      # Extract shard from path to check if enhanced
      pathParts = lib.splitString "/" (toString file);
      shard = builtins.elemAt pathParts (builtins.length pathParts - 3);
      isEnhanced = enhancedShards ? ${shard};
    in
    # Only apply enhanced defaults to packages that use stdenv directly
    if isEnhanced && result ? overrideAttrs then
      result.overrideAttrs (prev: {
        __structuredAttrs = prev.__structuredAttrs or enhancedDefaults.__structuredAttrs;
        enableParallelBuilding = prev.enableParallelBuilding or enhancedDefaults.enableParallelBuilding;
        strictDeps = prev.strictDeps or enhancedDefaults.strictDeps;
      })
    else
      result;
}
// mapAttrs (name: self._internalCallByNamePackageFile) packageFiles
