{ callPackage }:
builtins.mapAttrs (_: callPackage ./generic.nix) rec {
  wordpress = wordpress_7_1;
  wordpress_6_9 = {
    version = "6.9.7";
    hash = "sha256-Ef1l7Mv03V3l7LNyS1X5LFbWweqWdJf+k3S83XpvvaY=";
  };
  wordpress_7_0 = {
    version = "7.0.4";
    hash = "sha256-Jrmav8ZUJ/urUrJDFVOblE3O8UZ4maUla2wd4sSufkY=";
  };
  wordpress_7_1 = {
    version = "7.1";
    hash = "sha256-BaX4kTj2MrcynxIC8qBVPF9/5Nr45LnKfrrpuUZrnoY=";
  };
}
