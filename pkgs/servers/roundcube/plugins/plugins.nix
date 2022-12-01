{ callPackage }:

{
  inherit callPackage;

  roundcubePlugin = callPackage ./roundcube-plugin.nix { };

  carddav = callPackage ./carddav { };
  contextmenu = callPackage ./contextmenu { };
  persistent_login = callPackage ./persistent_login { };
  thunderbird_labels = callPackage ./thunderbird_labels { };
}
