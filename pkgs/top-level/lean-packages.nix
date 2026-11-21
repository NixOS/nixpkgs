# Lean 4 package set
#
# Override the toolchain for the entire set:
#   leanPackages.overrideScope (self: super: { lean4 = lean4-custom; })
{
  lib,
  newScope,
  lean4,
}:

lib.makeScope newScope (self: {
  inherit lean4;
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
  inherit (self.mathlib.passthru) mathlib__archive;
})
