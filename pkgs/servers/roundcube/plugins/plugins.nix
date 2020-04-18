{ callPackage }:

{
  inherit callPackage;

  roundcubePlugin = callPackage ./roundcube-plugin.nix { };

  persistent_login = callPackage ./persistent_login { };
}
