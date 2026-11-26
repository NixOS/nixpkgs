# Package sets

Package sets are defined here.
Most of them will get auto called through `pkgs/top-level/package-sets.nix`.

Any package set that has file `packageset.nix` is not automatically called.

There are several special files and directories:

## `by-name/` (optional)

Is a sharded directory structure for isolated package definitions as defined by RFC 140.
This sharded structure is checked in the CI by `nixpkgs-vet`.

## `functions.nix` (required)

Is an overlay containing definitons of functions
like `buildFishPlugin`, `buildPythonPackage`.
e.g.
```nix
self: super: {
  buildFooBarPackage = import ./buildFooBarPackage self;
}
```

## `manual-packages.nix` (required)

Is an overlay containing derivations outside the `by-name` structure like
- auto generated packages
- the migration of package sets will initially keep the `by-name` structure empty and
  only fill it gradually, simplifying the migration of large package sets

e.g.
```nix
self: super:
import ./generated.nix self super
// {
  foo = self.callPackage ./non-by-name/foobar;
}
```

## `aliases.nix` (required)

Is an overlay containing aliases for packages in the package set
like `pkgs/top-level/aliases.nix` does for the top-level.
e.g.
```nix
self: super:
let
  inherit (self.pkgs) lib;
in
{
  # (warnAlias would have to move to lib for this)
  fooo = lib.warnAlias "'fooo' has been renamed to 'foo'" self.foo;
  awawa_1 = builtins.throw "'awawa_1' has been removed, please use a newer version of 'awawa' like 'awawa_2'";
}
```

## `packageset.nix` (optional)

The entry point to a package set.
If it exists, it must be manually called from `pkgs/top-level/package-sets.nix`.

The `packageset.nix` MUST handle:
- the calling of the `by-name` structure (using `pkgs/top-level/by-name-overlay.nix`)
- overlaying the files `functions.nix`, `manual-packages.nix`, `aliases.nix`.
- asserting that each overlay does not override packages from the previous overlay.

e.g. for fooPackages
```nix
{
  lib,
  newScope,
}:
foo:
let
  dirname = "fooPackages";
in
lib.pipe (x: { inherit foo; }) [
  # overlay all autocalled by-name packages
  (lib.extends (
    self: super:
    let
      res = import ../../top-level/by-name-overlay.nix ./by-name self super;
      conflictingAttrs = lib.intersectAttrs res super;
    in
    assert lib.assertMsg (conflictingAttrs == { }) (
      "The following attributes were defined both in `pkgs/sets/${dirname}/by-name` and elsewhere: "
      + "${lib.concatStringsSep ", " (lib.attrNames conflictingAttrs)}"
    );
    res
  ))

  # overlay functions
  (lib.extends (
    self: super:
    let
      res = import ./functions.nix self super;
      conflictingAttrs = lib.intersectAttrs res super;
    in
    assert lib.assertMsg (conflictingAttrs == { }) (
      "The following attributes were defined both in `pkgs/sets/${dirname}/functions.nix` and elsewhere, "
      + "most likely in `pkgs/sets/${dirname}/by-name/`: "
      + (lib.concatStringsSep ", " (lib.attrNames conflictingAttrs))
    );
    res
  ))

  # overlay manual packages
  (lib.extends (
    self: super:
    let
      res = import ./manual-packages.nix self super;
      conflictingAttrs = lib.intersectAttrs res super;
    in
    assert lib.assertMsg (conflictingAttrs == { }) (
      "The following attributes were defined both in `pkgs/sets/${dirname}/manual-packages.nix` and elsewhere, "
      + "most likely in `pkgs/sets/${dirname}/by-name/` or `pkgs/sets/${dirname}/functions.nix`: "
      + (lib.concatStringsSep ", " (lib.attrNames conflictingAttrs))
    );
    res
  ))

  # overlay aliases
  (lib.extends (
    self: super:
    let
      res = import ./aliases.nix self super;
      conflictingAttrs = builtins.intersectAttrs res super;
    in
    assert lib.assertMsg (conflictingAttrs == { }) (
      "The following attributes were defined both in `pkgs/sets/${dirname}/aliases.nix` and elsewhere, "
      + "most likely in `pkgs/sets/${dirname}/by-name/`, `pkgs/sets/${dirname}/functions.nix` or `pkgs/sets/${dirname}/manual-packages.nix`: "
      + (lib.concatStringsSep ", " (lib.attrNames conflictingAttrs))
    );
    (lib.optionalAttrs config.allowAliases res)
  ))

  # make a new scope
  (lib.makeScope self.newScope)
]
```
