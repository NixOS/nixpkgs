# Lean 4 package set with its own toolchain (independent of pkgs.lean4).
#
# Override the toolchain for the entire set:
#   leanPackages.overrideScope (self: super: { lean4 = lean4-custom; })
{
  lib,
  newScope,
}:

lib.makeScope newScope (self: {
  lean4 = self.callPackage ../development/lean-modules/lean4 { };

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
