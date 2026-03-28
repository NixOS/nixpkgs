# Lean 4 package set.
#
# All packages are built against a single Lean toolchain version.
# Dependencies between packages use `leanDeps` which propagates
# .olean files via LEAN_PATH (through setup hooks), similar to how
# Haskell propagates package.conf.d entries.
#
# Overriding lean4 propagates to all packages in the set:
#   leanPackages.overrideScope (self: super: { lean4 = lean4-custom; })
#
# Usage:
#   leanPackages.batteries
#   leanPackages.mathlib
#   leanPackages.callPackage ./my-package.nix { }
{
  lib,
  newScope,
  lean4,
}:

lib.makeScope newScope (self: {
  inherit lean4;

  # Resolve via self.callPackage so overriding lean4 in the scope
  # propagates to the builder (same pattern as coqPackages).
  buildLakePackage = self.callPackage ../build-support/lake { };

  batteries = self.callPackage ../development/lean-modules/batteries { };

  aesop = self.callPackage ../development/lean-modules/aesop { };

  Qq = self.callPackage ../development/lean-modules/Qq { };

  proofwidgets = self.callPackage ../development/lean-modules/proofwidgets { };

  plausible = self.callPackage ../development/lean-modules/plausible { };

  LeanSearchClient = self.callPackage ../development/lean-modules/LeanSearchClient { };

  Cli = self.callPackage ../development/lean-modules/Cli { };

  importGraph = self.callPackage ../development/lean-modules/importGraph { };

  mathlib = self.callPackage ../development/lean-modules/mathlib { };
})
