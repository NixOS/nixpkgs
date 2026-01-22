# Package sets


Package sets here _must_ have a sub directory called `by-name/`
and the files `overrides.nix`, `functions.nix`, `aliases.nix` and `manual-packages.nix`.

Package sets here _may_ have a file `packageset.nix` which results in them not being autocalled.
All package sets without this file are autocalled.

## `by-name/`

Is a sharded directory structure for isolated package definitions as defined by RFC 140.
This sharded structure is checked in the CI by `nixpkgs-vet`.
If there are no packages that fit into this structure, it may be empty.

## `overrides.nix`

Is an overlay containing overrides for packages in the `by-name` structure.
This is something we try to keep empty (`final: prev: {}`).
Most, maybe all, overrides can be inlined in the package.
e.g.
```nix
final: prev: {
  # inlineability debateable since it complicates overriding
  fooFull = final.foo.override {
    withMeow = true;
    withBeep = true;
  };

  # useless inlineable override
  bar = final.callPackage by-name/bar/package.nix {
    foo = final.fooFull;
  };
}
```

## `functions.nix`
Is an overlay containing definitons of functions
like `buildFishPlugin`, `buildPythonPackage`.
e.g.
```nix
final: prev: {
  buildFooBarPackage = import ./buildFooBarPackage final;
}
```

## `aliases.nix`
Is an overlay containing aliases for packages in package sets behind `optionalAttrs config.allowAliases`
like `top-level/aliases.nix` does for the top-level.
e.g.
```nix
final: prev:
let
  inherit (final) lib;
in
{
  # (warnAlias would have to move to lib for this)
  fooo = lib.warnAlias "'fooo' has been renamed to 'foo'" final.foo;
  awawa_1 = builtins.throw "'awawa_1' has been deprecated, please use a newer version of 'awawa' like 'awawa_2'";
}
```

## `manual-packages.nix`
Is an overlay containing derivations outside the `by-name` structure like
- auto generated packages
- the migration of (large) package sets can initially keep the `by-name` structure empty and
  only fill it gradually, simplifying the migration of large package sets


## `packageset.nix`

The `packageset.nix` _must_ handle the calling of the `by-name` structure
(which should be easy by using `pkgs/top-level/by-name-overlay.nix`)
as well as the files `overrides.nix`, `functions.nix`, `aliases.nix` and `manual-packages.nix`.
Since the `packageset.nix` is not automatically called
there is no need to place any more restrictions on this file,
which allows package sets to be flexible.
Calling these package sets should be done in a file in `pkgs/top-level` e.g.
- `top-level/package-sets.nix` → have all package sets in one place
- `top-level/all-packages.nix` → only have autocalled packages in a separate file → file is small

e.g.
```nix
{
  lib,
  newScope,
}:
python:
lib.makeScope newScope (
  self:
  lib.fix (
    lib.extend
      (x: {
        inherit python;
      })
      [
        (import ../../top-level/by-name-overlay.nix ./by-name)
        (lib.extends (
          self: super:
          lib.optionalAttrs self.config.allowAliases (import (../sets/${name}/aliases.nix) self super)
        ))
        (import ./functions.nix)
        (import ./manual-packages.nix)
        (import ./overrides.nix)
      ]
  )
)
```
