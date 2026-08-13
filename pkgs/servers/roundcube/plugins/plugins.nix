{ callPackage }:

{
  inherit callPackage;

  roundcubePlugin = callPackage ./roundcube-plugin.nix { };

  carddav = callPackage ./carddav { };
  contextmenu = callPackage ./contextmenu { };
  custom_from = callPackage ./custom_from { };
  persistent_login = callPackage ./persistent_login { };
  thunderbird_labels = callPackage ./thunderbird_labels { };
}
