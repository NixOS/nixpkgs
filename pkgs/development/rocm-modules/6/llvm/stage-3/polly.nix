{
  stdenv,
  callPackage,
  rocmUpdateScript,
}:

callPackage ../base.nix rec {
  inherit stdenv rocmUpdateScript;
  targetName = "polly";
  targetDir = targetName;

  extraPostPatch = ''
    # `add_library cannot create target "llvm_gtest" because an imported target with the same name already exists`
    substituteInPlace CMakeLists.txt \
      --replace-fail "NOT TARGET gtest" "FALSE"
  '';

  checkTargets = [ "check-${targetName}" ];
}
