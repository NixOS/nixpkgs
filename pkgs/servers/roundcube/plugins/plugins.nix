{ callPackage }:

{
  inherit callPackage;

  roundcubePlugin = callPackage ./roundcube-plugin.nix { };

  carddav = callPackage ./carddav { };
  persistent_login = callPackage ./persistent_login { };
}
