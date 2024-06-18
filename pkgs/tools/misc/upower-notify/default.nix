{ lib, buildGoModule, fetchFromGitHub, fetchpatch }:

# To use upower-notify, the maintainer suggests adding something like this to your configuration.nix:
#
# service.xserver.displayManager.sessionCommands = ''
#   ${pkgs.dunst}/bin/dunst -shrink -geometry 0x0-50-50 -key space & # ...if don't already have a dbus notification display app
#   (sleep 3; exec ${pkgs.yeshup}/bin/yeshup ${pkgs.go-upower-notify}/bin/upower-notify) &
# '';
buildGoModule {
  pname = "upower-notify";
  version = "0-unstable-2019-01-06";

  src = fetchFromGitHub {
    owner = "omeid";
    repo = "upower-notify";
    rev = "7013b0d4d2687e03554b1287e566dc8979896ea5";
    sha256 = "sha256-8kGMeWIyM6ML1ffQ6L+SNzuBb7e5Y5I5QKMkyEjSVEA=";
  };

  patches = [
    # Migrate to Go module
    (fetchpatch {
      url = "https://github.com/omeid/upower-notify/commit/dff8ad7e33e5b0cf148e73c6ea0c358da72006ed.patch";
      hash = "sha256-zPSryo6f+6QGgjOkC3W1fPIbZ3FD6S/rAuBJXHWqjZg=";
    })
  ];

  vendorHash = "sha256-58zK6t3rb+19ilaQaNgsMVFQBYKPIV40ww8klrGbpnw=";
  proxyVendor = true;

  meta = with lib; {
    description = "simple tool to give you Desktop Notifications about your battery";
    mainProgram = "upower-notify";
    homepage = "https://github.com/omeid/upower-notify";
    maintainers = with maintainers; [ kamilchm ];
  };
}
