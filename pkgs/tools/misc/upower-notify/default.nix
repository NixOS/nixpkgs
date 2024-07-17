{
  lib,
  buildGoPackage,
  fetchFromGitHub,
}:

# To use upower-notify, the maintainer suggests adding something like this to your configuration.nix:
#
# service.xserver.displayManager.sessionCommands = ''
#   ${pkgs.dunst}/bin/dunst -shrink -geometry 0x0-50-50 -key space & # ...if don't already have a dbus notification display app
#   (sleep 3; exec ${pkgs.yeshup}/bin/yeshup ${pkgs.go-upower-notify}/bin/upower-notify) &
# '';
buildGoPackage rec {
  pname = "upower-notify";
  version = "unstable-2016-03-10";

  goPackagePath = "github.com/omeid/upower-notify";

  src = fetchFromGitHub {
    owner = "omeid";
    repo = "upower-notify";
    rev = "14c581e683a7e90ec9fa6d409413c16599a5323c";
    sha256 = "16zlvn53p9m10ph8n9gps51fkkvl6sf4afdzni6azk05j0ng49jw";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "simple tool to give you Desktop Notifications about your battery";
    mainProgram = "upower-notify";
    homepage = "https://github.com/omeid/upower-notify";
    maintainers = with maintainers; [ kamilchm ];
  };
}
