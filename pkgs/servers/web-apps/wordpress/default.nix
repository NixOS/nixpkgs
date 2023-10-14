{ callPackage }: builtins.mapAttrs (_: callPackage ./generic.nix) rec {
  wordpress = wordpress6_3;
  wordpress6_3 = {
    version = "6.3.2";
    hash = "sha256-Jo2/Vlm4Ml24ucPI6ZHs2mkbpY2rZB1dofmGXNPweA8=";
  };
}
