{ callPackage }: builtins.mapAttrs (_: callPackage ./generic.nix) rec {
  wordpress = wordpress6_3;
  wordpress6_3 = {
    version = "6.3.2";
    hash = "sha256-Jo2/Vlm4Ml24ucPI6ZHs2mkbpY2rZB1dofmGXNPweA8=";
  };
  wordpress6_4 = {
    version = "6.4.1";
    hash = "sha256-NF3tvVNUYlKPvtvJZzM7djGflOUT4VUlm4AyHPFzfdw=";
  };
}
