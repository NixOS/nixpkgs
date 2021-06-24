{ lib, buildGoPackage, fetchgit }:

# To use upower-notify, the maintainer suggests adding something like this to your configuration.nix:
#
# service.xserver.displayManager.sessionCommands = ''
#   ${pkgs.dunst}/bin/dunst -shrink -geometry 0x0-50-50 -key space & # ...if don't already have a dbus notification display app
#   (sleep 3; exec ${pkgs.yeshup}/bin/yeshup ${pkgs.go-upower-notify}/bin/upower-notify) &
# '';
buildGoPackage rec {
  pname = "upower-notify";
  version = "20160310-${lib.strings.substring 0 7 rev}";
  rev = "14c581e683a7e90ec9fa6d409413c16599a5323c";

  goPackagePath = "github.com/omeid/upower-notify";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/omeid/upower-notify";
    sha256 = "16zlvn53p9m10ph8n9gps51fkkvl6sf4afdzni6azk05j0ng49jw";
  };

  goDeps = ./deps.nix;
}
